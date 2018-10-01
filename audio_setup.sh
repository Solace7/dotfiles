#!/bin/bash
echo -e `date` "\n" >> $HOME/.local$HOME/.local/var/log/audiosetuplog
#alsactl store
echo "Starting JACK" >> $HOME/.local/var/log/audiosetuplog
jack_control start | tee -a $HOME/.local/var/log/audiosetuplog
jack_control ds alsa | tee -a $HOME/.local/var/log/audiosetuplog

if [ -d "/proc/asound/CODEC" ]; then
    #Audio Interface
    jack_control dps device hw:CODEC | tee -a $HOME/.local/var/log/audiosetuplog
else
    #Internal Audio
    jack_control dps device hw:PCH | tee -a $HOME/.local$HOME/.local/var/log/audiosetuplog

fi

jack_control dps rate 44100 | tee -a $HOME/.local/var/log/audiosetuplog
jack_control dps nperiods 3 | tee -a $HOME/.local/var/log/audiosetuplog
jack_control dps period 512 | tee -a $HOME/.local/var/log/audiosetuplog
sleep 10
echo -e "Connecting a2j MIDI \n" >> $HOME/.local/var/log/audiosetuplog
killall -9 a2jmidid
a2jmidid -ue & >> $HOME/.local/var/log/audiosetuplog
sleep 10
pactl set-default-sink jack_out
echo "jack_out set as default sink" >> $HOME/.local/var/log/audiosetuplog
pactl set-default-source jack_in
echo "jack_in set as default source" >> $HOME/.local/var/log/audiosetuplog
#alsactl restore
notify-send "JACK Audio Connection Kit is connected and set for MIDI"
echo "Jack Setup Complete" >> $HOME/.local/var/log/audiosetuplog
echo "Peripheral Check" >> $HOME/.local/var/log/audiosetuplog
if [ -d "/proc/asound/Mic" ]; then
		echo "Samson Meteor Mic is Connected" >> $HOME/.local/var/log/audiosetuplog
		samson_mic
		samson_speaker
fi

echo -e "Starting Cadence \n" >> $HOME/.local/var/log/audiosetuplog
#cadence --minimized &
#qjackctl &

echo -e "Done \n" >> $HOME/.local/var/log/audiosetuplog
echo `date` >> $HOME/.local/var/log/audiosetuplog

if [[ $(wc --lines $HOME/.local/var/log/audiosetuplog) > 32 ]]; then
    rm $HOME/.local/var/log/audiosetuplog
    touch $HOME/.local/var/log/audiosetuplog
    echo "Audio Setup Completed. New log file created" >> $HOME/.local/var/log/audiosetuplog
    echo `date` >> $HOME/.local/var/log/audiosetuplog
fi

exit 1
