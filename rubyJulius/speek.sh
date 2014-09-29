open_jtalk -m /usr/local/share/hts_voice/nitech_jp_atr503_m001.htsvoice -x /usr/local/dic -ow message.wav speak.txt
mplayer message.wav
rm message.wav speak.txt
