# MIDILearnViewController
A simple CoreMIDI example, demonstrating the common 'Midi Learn' feature.

The example Xcode project contains MIDILearnViewController, a UIViewController subclass that handles the entire learn operation:

1. Setup a Midi client on the main thread.
2. Parse Midi information in the callback.
3. Send results back onto the main thread. 
4. Dispose of the Midi client, on the main thread.

A protocol named MIDILearnViewControllerDelegate has been declared, along with a weak property reference named delegate, and can be used to inform the presenting view controller (or any object that your heart desires) of the results.
