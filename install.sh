#! /bin/sh

git clone --branch "v4.0.1" https://github.com/lorentey/BTree.git
git clone --branch "0.6.7" https://github.com/krzyzanowskim/CryptoSwift.git
git clone https://github.com/raywenderlich/swift-algorithm-club.git
cd swift-algorithm-club
git checkout "ecd560f76ed95fed54dd77a431a187ce35851533"
