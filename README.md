# Computer-Vision

# SIFT特征匹配RANSAC剔除错误

## 一、基本原理
 Sift是计算机视觉里面一个提取特征的经典方法，翻译即尺度不变特性转换，他在空间尺度中寻找极值点，并提取出其位置、尺度、旋转不变量，局部影像特征的描述与侦测可以帮助辨识物体，SIFT特征是基于物体上的一些局部外观的兴趣点而与影像的大小和旋转无关。对于光线、噪声、些微视角改变的容忍度也相当高，其基本步骤一般分为：用高斯核构建尺度空间，形成高斯金字塔，在DoG尺度空间中检测极值点，计算特征点方向，计算128维描述子。
本文内容主要是实现ransac算法，其基本思想就是对处理数据进行随机采样，然后利用采样的数据对所有数据进行误差评估，每一次采样都会得到一个结果，在经历足够多次采样之后可以找到一次采样使误差达到最小，这就是ransac的基本思想。

## 二、核心代码
Sift的实现代码是 https://www.cs.ubc.ca/~lowe/keypoints/ 网站上下载的，这个应该是 加拿大University of British Columbia 大学计算机科学系教授 David G. Lowe发表的matlab代码，里面有很多文件sift.m是提取特征值，match.m是匹配两幅图像的特征值，我写了一个CaflF.m用来实现ransac算法并计算基本矩阵F，并在ransac.m中调用CaflF.m实现特征匹配

## 三、流程图
![Image](https://github.com/AOYLAOTANG/ImageSource/blob/main/CV/sift/CV-sift1.png)
![Image](https://github.com/AOYLAOTANG/ImageSource/blob/main/CV/sift/CV-sift2.png)
左边为Sift的流程图，右边为ransac流程图

## 四、实验结果
做了三个实验，分别对误差的参数dis进行了测试
Dis<0.5
![Image](https://github.com/AOYLAOTANG/ImageSource/blob/main/CV/sift/CV-sift3.png)
![Image](https://github.com/AOYLAOTANG/ImageSource/blob/main/CV/sift/CV-sift4.png)

Dis<0.1
![Image](https://github.com/AOYLAOTANG/ImageSource/blob/main/CV/sift/CV-sift5.png)
![Image](https://github.com/AOYLAOTANG/ImageSource/blob/main/CV/sift/CV-sift6.png)

Dis<0.05
![Image](https://github.com/AOYLAOTANG/ImageSource/blob/main/CV/sift/CV-sift7.png)
![Image](https://github.com/AOYLAOTANG/ImageSource/blob/main/CV/sift/CV-sift8.png)

## 五、总结
通过这次实现ransac，刚开始使用人脸做特征匹配，后来效果不太好，发现人脸还是纹理比较少，后面网上搜了很多图实验，发现景观或者纹理比较复杂的图片提取的特征的比较多，像人脸一般就两三个特征点，ransac方法主要思想比较简单，主要是实现到sift特征提取中，网上查了很多资料，中间也问过老师，后来看matlab本身自带的实现函数，因为调用函数太多了就自己模仿写了一个，基本思想就是8点法求一个线性方程组确定一个基础矩阵F，然后对每个特征点用这个F算极线，找匹配点与极线的距离dis，如果在某个范围内就算inlier，否则就是误差点，需要剔除，放到outliner中，开始dis设置的值比较大，所以剔除的误差不算很多，后来dis设置小一点，即缩小极线的区域，发现剔除效果就比较好了

