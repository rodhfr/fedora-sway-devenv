#!/usr/bin/env python3
import gi
gi.require_version("Playerctl", "2.0")
from gi.repository import Playerctl, GLib
import sys
import signal
import json

# Terminar script com Ctrl+C
def signal_handler(sig, frame):
    sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)
signal.signal(signal.SIGTERM, signal_handler)

loop = GLib.MainLoop()
manager = Playerctl.PlayerManager()

# Função para escrever no stdout em formato JSON para Waybar
def write_output(player):
    artist = (player.get_artist() or "").strip()
    title = (player.get_title() or "").strip()
    
    # Texto final
    track = ""
    if artist and title:
        track = f"{artist} - {title}"
    else:
        track = artist or title or ""
    
    # Ícone de status
    if player.props.status == "Playing":
        track = " " + track
    elif player.props.status == "Paused":
        track = " " + track
    
    output = {"text": track, "class": "custom-mpv", "alt": "mpv"}
    sys.stdout.write(json.dumps(output) + "\n")
    sys.stdout.flush()

# Callback quando o player muda a música ou o status
def on_metadata_changed(player, metadata, _=None):
    write_output(player)

def on_playback_status_changed(player, status, _=None):
    write_output(player)

# Callback quando um player aparece
def on_player_appeared(_, player_name):
    if player_name != "mpv":
        return
    player = Playerctl.Player.new_from_name(player_name)
    player.connect("metadata", on_metadata_changed)
    player.connect("playback-status", on_playback_status_changed)
    manager.manage_player(player)
    write_output(player)

# Callback quando o player fecha
def on_player_vanished(_, player):
    sys.stdout.write(json.dumps({"text": "", "class": "custom-mpv", "alt": "mpv"}) + "\n")
    sys.stdout.flush()

# Conectar callbacks do PlayerManager
manager.connect("name-appeared", on_player_appeared)
manager.connect("player-vanished", on_player_vanished)

# Inicializa players já existentes
for name in manager.props.player_names:
    on_player_appeared(None, name)

# Loop principal
loop.run()

