# SeeFood

SeeFood is a very simple iOS app that I wrote for identifying food. Given an
image, SeeFood will try to determine whether the subject is a **hot dog** or
**not a hot dog**. SeeFood is a fork of
[Garbage Vision](/projects/garbage-vision) with the Garbage Net Core ML model
replaced with the Hot Dog Net Core ML model. Classification is handled
exceedingly well by the Hot Dog Net Core ML model, which I created using
Apple's Create ML app and trained using the
[Hot Dog - Not Hot Dog](https://www.kaggle.com/dansbecker/hot-dog-not-hot-dog)
dataset from Kaggle by DanB. In practice, I've noticed that classification has
been mostly accurate, with the only minor quirk being an issue in
differentiating between hot dog and hamburger, which imo are basically the
same 🤣.

SeeFood takes inspiration from Jian-Yang's "SeeFood" app in HBO's Silicon
Valley TV series, which can only classify foods as **hot dog** or
**not hot dog**. I wrote this app as a joke after showing Garbage Vision to my
friends a day earlier.

<div id="image-table">
  <table>
    <tr>
      <td style="padding:10px">
        <img src="https://github.com/j43cheun/SeeFood/blob/main/Screenshots/main-screen.png"/>
      </td>
      <td style="padding:10px">
        <img src="https://github.com/j43cheun/SeeFood/blob/main/Screenshots/hot-dog-classification.png"/>
      </td>
      <td style="padding:10px">
        <img src="https://github.com/j43cheun/SeeFood/blob/main/Screenshots/hot-dog-confidence-scores.png"/>
      </td>
      <td style="padding:10px">
        <img src="https://github.com/j43cheun/SeeFood/blob/main/Screenshots/not-a-hot-dog-classification.png"/>
      </td>
      <td style="padding:10px">
        <img src="https://github.com/j43cheun/SeeFood/blob/main/Screenshots/not-a-hot-dog-confidence-scores.png"/>
      </td>
    </tr>
  </table>
</div>
