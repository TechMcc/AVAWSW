open_jtalk -m /usr/local/share/hts_voice/mei_normal.htsvoice -x /usr/local/dic -ow message.wav speak.txt
mplayer message.wav
rm message.wav speak.txt
