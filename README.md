# NotHotDog

What would you say if I told you there is a app on the market that tell you if you have a hotdog or not a hotdog.

![Jianyang](https://media.tenor.com/images/2d53cca00c6c20cab18a37ba3c49dc53/tenor.gif)

This app is a clone of Jian Yang's SeeFood app from HBO's [Silicon Valley](https://www.imdb.com/title/tt2575988/).

<table style={border:"none"}><tr>
<td><img src="https://user-images.githubusercontent.com/29589003/65856843-8cc82700-e35a-11e9-8c20-b169b0dcac4c.png" alt="Screenshot 1"/></td>
<td><img src="https://user-images.githubusercontent.com/29589003/65856848-8df95400-e35a-11e9-9550-1e2e89849cbb.png" alt="Screenshot 2"/></td>
<td><img src="https://user-images.githubusercontent.com/29589003/65882429-eea18480-e38c-11e9-8adb-1d3ebd988bb4.png" alt="Screenshot 3"/></td>
</tr>

</table>

The first screen has a live viewfinder and two buttons, one to capture the image from the viewfinder and the other to select an image from the gallery.
For the live viewfinder I used the [camera](https://pub.dev/packages/camera) plugin.Once an image has been selected the application will be then directed to the second screen where the power of Machine learning will help us label the image. For this, I have used [mlkit](https://pub.dev/packages/mlkit) plugin to utilize the Label Detection offered by Firebase.

The LabelDetector returned a List of VisionLabel objects, whose label property defines what the detected image is of. To find out if the image contained HotDog , I just queried if the list contained a VisionLabel of ‘Hot dog’ and after a bit of tinkering here and there, the app was ready.

To run this app on your phone you can download the apk [here](https://drive.google.com/file/d/1RXUGdVFPQs7jaEnHqEANJboAN7K6ojJL/view).

If you want to build the application yourself you can:

1. Create a project in Firebase and add an android app
2. Download the **googleServices.json**
3. Paste it inside *android/app/* and you're good to go.

You can also read the article [here](https://medium.com/@bimsina/building-jian-yangs-seefood-app-in-flutter-c3526c186860).
