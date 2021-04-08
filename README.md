# FlowerBud

- This project is a experiment of CoreML use. I follow the section 24 classes of App Brewary iOS course: https://www.udemy.com/course/ios-13-app-development-bootcamp/
- This projet use CoreML to classify a flower photo and search from Wikipedia API a brief text about recognized flower
- This is the original model used https://drive.google.com/uc?export=download&id=13v58uJqi_pAXKoBa2J7mZ7sLkaSRVUBb named oxford102.coffemodel
- Oxford102.coffemodel was parsed by CoreML model using coremltools (https://pypi.org/project/coremltools/)
- I made just a small modification using MLKitTranslate to translate from english to portuguse wekepidia texts

## Installation

Open your terminal and type in

```sh
$ git clone https://github.com/IsaacCavalcante/FlowerBud.git
$ cd FlowerBud
$ pod install
```

## How to use

After download or clone the project you need download this file:
https://drive.google.com/file/d/1LYn4Gb__fL2uBA9GPzSajNuwtmrH2u-d/view?usp=sharing

This file is the model used by CoreML to classify flowers

after downloded it drop this file to FlowerBud.xcodeproj, change Signing Team in Signing & Capabilities in order to build in your device, run and voilà!

If you have any question, ask me. You will find my contact going to my github profile

## Bugs

The classification is not too good yet. I dont know why, but hope soon I find why.
Currently the traduction is working just from english to portuguese.

