# 双目视觉匹配计算视差深度

## 一、基本原理
Stereo双目立体匹配有很多算法， 比如SAD、BM、SGBM、GC，差别在于匹配时候的策略不同，我们这次要用到的NCC度量就是一种不错的方法。
![Image](https://github.com/AOYLAOTANG/ImageSource/blob/main/CV/stereo/CV-stereo1.png)
其中I为目标图像，T为模板图像，模板大小为M*N。

NCC的基本思想就是，从左边图像选取一个区域块，在右边目标图像某个范围内滑动，计算相似度ncc记录到对应的滑动距离中，然后选择相似度最高的距离d作为这个区域块的视差d即两幅图像这个相同区域所处像素值的差值，计算完所有区域之后的就可以得到一个视差图，根据相机的内置参数既可以求出深度图。

下面这个图很好的解释了视差和深度之间的关系。
![Image](https://github.com/AOYLAOTANG/ImageSource/blob/main/CV/stereo/CV-stereo2.png)

## 二、核心代码

myncc.m

## 三、流程图
![Image](https://github.com/AOYLAOTANG/ImageSource/blob/main/CV/stereo/CV-stereo3.png)

## 四、实验结果
接下来我们用两组图来测试算法：
![Image](https://github.com/AOYLAOTANG/Computer-Vision/blob/main/stereo%E5%8F%8C%E7%9B%AE%E5%8C%B9%E9%85%8D/im2.jpg)
![Image](https://github.com/AOYLAOTANG/Computer-Vision/blob/main/stereo%E5%8F%8C%E7%9B%AE%E5%8C%B9%E9%85%8D/im6.jpg)
![Image](https://github.com/AOYLAOTANG/Computer-Vision/blob/main/stereo%E5%8F%8C%E7%9B%AE%E5%8C%B9%E9%85%8D/teddy1.png)
![Image](https://github.com/AOYLAOTANG/Computer-Vision/blob/main/stereo%E5%8F%8C%E7%9B%AE%E5%8C%B9%E9%85%8D/teddy2.png)

刚开始得到的结果比较辣眼睛，后来发现原来是滑动区域范围不对
![Image](https://github.com/AOYLAOTANG/ImageSource/blob/main/CV/stereo/CV-stereo4.png)

改进之后就效果还不错了
![Image](https://github.com/AOYLAOTANG/ImageSource/blob/main/CV/stereo/CV-stereo5.png)

然后是泰迪熊，感觉效果还不错。
![Image](https://github.com/AOYLAOTANG/ImageSource/blob/main/CV/stereo/CV-stereo6.png)

## 五、总结分析
 这次实验花了很长时间，实现并不难，但是刚开始实验的效果不太好，找了很多资料，一开始以为自己的代码写的有问题，但是看了很多遍觉得没什么大错误。然后就自己假设相机的参数，根据视差求深度，开始生成的结果上面也展示了，轮廓提取了一部分，但是深度比较小的区域基本就是一团糟。

后来仔细分析了一下数据，发现第一组图左图和第一组图右图的位置关系，发现左图相当于右图左移得到的结果，所以这个滑动距离应该设置为负数，从-60滑动到0，开始我设置的是-30到30，应该是滑动区域不够，找不到最匹配的区域，所以匹配的效果不太好，改动之后效果果然还不错，然后对ncc值小于0.5的认为是错误相似配对，把这些点剔除掉，然后用空洞填充把这些点用周围的像素填充，最后结果也算还行吧，双目测深原理并不是很难，但是有些细节没有把握住就导致最后结果千差万别。
