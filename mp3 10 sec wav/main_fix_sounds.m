% This part takes the sound file and generates a new sound file
% In this new sound file in one of the stereo channels you get the song
% in the second channel you have a square wave function which marks the
% start of the song

fixSoundFile('-soundFileName', 'funky.wav', '-prefix', 'fix_', '-showFig',1,'-minPeakHeight',0.12,'-playSound',1);
fixSoundFile('-soundFileName', 'hit me baby.wav', '-prefix', 'fix_', '-showFig',1,'-minPeakHeight',0.12,'-playSound',1);
fixSoundFile('-soundFileName', 'haleluia.wav', '-prefix', 'fix_', '-showFig',1,'-minPeakHeight',0.12,'-playSound',1);
fixSoundFile('-soundFileName', 'noise.wav', '-prefix', 'fix_', '-showFig',1,'-minPeakHeight',0.12,'-playSound',1);
fixSoundFile('-soundFileName', 'queen2.wav', '-prefix', 'fix_', '-showFig',1,'-minPeakHeight',0.12,'-playSound',1);
fixSoundFile('-soundFileName', 'sandman.wav', '-prefix', 'fix_', '-showFig',1,'-minPeakHeight',0.12,'-playSound',1);
fixSoundFile('-soundFileName', 'take5.wav', '-prefix', 'fix_', '-showFig',1,'-minPeakHeight',0.12,'-playSound',1);
fixSoundFile('-soundFileName', 'tocata.wav', '-prefix', 'fix_', '-showFig',1,'-minPeakHeight',0.12,'-playSound',1);
