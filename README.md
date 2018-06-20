# SoundClassifier
A Processing tool for analysing sound inputs into a running spectrogram. The pixel array is send with OSC to Wekinator for IML sound classification. 

# Setup 🔧
To setup the tool follow the instructions: 

1. Downloade and install Processing https://processing.org/download/

2. Install the ocsP5, Minim, and ControlP5 libraries 

3. Download and install Wekinator http://www.wekinator.org/downloads/

4. Start a new project, and set inputs to 1600. This should match the specogram resolution in the sketch. 900 is the default. 

5. Set output to 1 and set "All Classifier" as the type an continue. 

6. Run the Processing sketch and start classifing. 


# Usage
The tool keeps sending the spectogram pixel array as inputs to Wekinator.
Choose a class in Wekinator, and press record. While recording everything
shown in the spectogram will be used to train the class.

Make sure to use continiously
fill the spectogram with the sentence/word/sound that you want to classify. For a small demonstrates see this video: 
https://vimeo.com/276021078

# OPS 
You might notice that the output in wekinator will flicker as seem noisy. I've implemented a smoother algorithm in the processing sketch that needs a specific amount of similar outputs in a row before it accepts and uses the output. This gives a little delay but feels natural when working with sounds in a longer time domain. 
