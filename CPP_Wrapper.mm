//
//  CPP_Wrapper.m
//  openCViOS
//
//  Created by ozcan akkoca on 12/11/2016.
//  Copyright © 2016 ozcan akkoca. All rights reserved.
//

#import "CPP_Wrapper.h"
#include <iostream>
#include<opencv2/imgproc/imgproc.hpp>
#include<opencv2/highgui/highgui.hpp>
#include <opencv2/opencv.hpp>
#include <opencv2/imgcodecs/ios.h>
#import "CPP.hpp"

@implementation CPP_Wrapper

using namespace std;
using namespace cv;

- (void)helloCPPWrapper:(NSString *)name {
    std::cout << "Hello++ " << [name cStringUsingEncoding:NSUTF8StringEncoding] << " in C++" << std::endl;
    // CPP::helloCPP("sa");
}

//--------------------------------------------------------
//--------------------------------------------------------
/*
 Öklid
 Şehir blok
 Satranç
 Kontrastgerme
 Eşikleme
 Negatif
 Üs alma
 logaritma
 Gama
 Bitwise
 Karekok
 Histogram
 
 
 Ortalama Alma
 Medyan Min Max
 Laplace
 Sobel
 
 
 Gauss Noise
 Salt & Papper
 
 
 RGB -> HSI
 Histogramlarını alma
 Gürültü
 
 Canny
 Prewit
 
 Aşınma erode
 Genişleme dilate
 Kapama 
 Açma
 
 
 Gauss Blur 
 Resmi Çevirme İşlemleri
 // 32 Kod var
 */
//--------------------------------------------------------

double euclideanDistance(Point2f a, Point2f b) {
    double x = a.x - b.x;
    double y = a.y - b.y;
    
    return sqrt(powf((x * x),2) + powf((y * y),2));
}


double cityBlock(Point2f a, Point2f b) {
    double x = a.x - b.x;
    double y = a.y - b.y;
    
    
    return abs(x) + abs(y);
}

double chessboardDistance(Point2f a, Point2f b) {
    double x = a.x - b.x;
    double y = a.y - b.y;
    
    
    return abs(x) > abs(y) ? abs(x) : abs(y);
}

// kontrastgerme(dst, 80, 150);
void kontrastgerme1 (Mat& dst, int small, int big) {
    for(int y = 0; y < dst.rows; y++)
        for(int x = 0; x < dst.cols; x++) {
            if (dst.at<uchar>(y, x) < small) {
                dst.at<uchar>(y, x) = 0;
            }
            
            if (dst.at<uchar>(y, x) > big) {
                dst.at<uchar>(y, x) = 255;
            }
        }
}

// esikleme(dst, 150);
void esikleme (Mat& dst, int esik) {
    for(int y = 0; y < dst.rows; y++)
        for(int x = 0; x < dst.cols; x++) {
            if (dst.at<uchar>(y, x) < esik) {
                dst.at<uchar>(y, x) = 0;
            }
            
            if (dst.at<uchar>(y, x) > esik) {
                dst.at<uchar>(y, x) = 255;
            }
        }
}

// negatif(dst);
void negatif (Mat& dst) {
    for(int y = 0; y < dst.rows; y++)
        for(int x = 0; x < dst.cols; x++) {
            dst.at<uchar>(y,x) = 256 - 1 - dst.at<uchar>(y,x);
        }
}



void usAlma (Mat& src, Mat& dst) {
    for(int y = 0; y < dst.rows; y++)
        for(int x = 0; x < dst.cols; x++) {
            dst.at<double>(y,x) =  pow(src.at<double>(y, x), x);
        }
}

//us alma
void GammaCorrection(Mat& src, Mat& dst, float fGamma)

{
    unsigned char lut[256];
    
    for (int i = 0; i < 256; i++) {
        lut[i] = saturate_cast<uchar>(1 * pow((float)(i / 255.0), fGamma) * 255.0f);
    }
    
    dst = src.clone();
    
    for(int y = 0; y < dst.rows; y++)
        for(int x = 0; x < dst.cols; x++) {
            dst.at<uchar>(y,x) =  lut[dst.at<uchar>(y,x)];
        }
}

void BitWise(Mat& src, Mat& dst, int bit)

{
    dst = src.clone();
    
    for(int y = 0; y < dst.rows; y++)
        for(int x = 0; x < dst.cols; x++) {
            dst.at<uchar>(y,x) = src.at<uchar>(y,x) & bit;
        }
}

void logaritma (Mat &dst, int c) {
    for (int i = 0; i < dst.rows; i++) {
        for (int j = 0; j <dst.cols; j++) {
            dst.at<uchar>(i, j) = c*(log(1 + dst.at<uchar>(i, j)));
        }
    }
}
void imhist(Mat &image, int histogram[])
{
    
    // initialize all intensity values to 0
    for(int i = 0; i < 256; i++)
    {
        histogram[i] = 0;
    }
    
    // calculate the no of pixels for each intensity values
    for(int y = 0; y < image.rows; y++)
        for(int x = 0; x < image.cols; x++)
            histogram[(int)image.at<uchar>(y,x)]++;
    
}

void cumhist(int histogram[], int cumhistogram[])
{
    cumhistogram[0] = histogram[0];
    
    for(int i = 1; i < 256; i++)
    {
        cumhistogram[i] = histogram[i] + cumhistogram[i-1];
    }
}

void histogram(Mat &img, Mat &dst)
{
    // Generate the histogram
    int histogram[256];
    imhist(img, histogram);
    
    // Caluculate the size of image
    int size = img.rows * img.cols;
    float alpha = 255.0/size;
    
    
    
    // Generate cumulative frequency histogram
    int cumhistogram[256];
    cumhist(histogram,cumhistogram );
    
    // Scale the histogram
    int Sk[256];
    for(int i = 0; i < 256; i++)
    {
        Sk[i] = cvRound((double)cumhistogram[i] * alpha);
    }
    
    // Generate the equlized image
    for(int y = 0; y < img.rows; y++)
        for(int x = 0; x < img.cols; x++)
            dst.at<uchar>(y,x) = saturate_cast<uchar>(Sk[img.at<uchar>(y,x)]);
    
}

void ortalama(Mat& img, Mat& dst) {
    
    float sum, count;
    float Kernel[3][3] = {
        {1.0, 1.0, 1.0},
        {1.0, 1.0, 1.0},
        {1.0, 1.0, 1.0}
    };
    
    //convolution operation
    for(int y = 0; y < img.rows; y++){
        for(int x = 0; x < img.cols; x++){
            sum = 0.0;
            count = 0.0;
            for(int k = -1; k <= 1;k++){
                for(int j = -1; j <=1; j++){
                    if ((y-j) > 0 && (x-k) > 0 && (y-j) < img.rows && (x-k) < img.cols) {
                        sum = sum + Kernel[j+1][k+1]*img.at<uchar>(y - j, x - k);
                        count++;
                    }
                }
            }
            dst.at<uchar>(y,x) = sum / count;
        }
    }
    
}

void insertionSort(int window[])
{
    int temp, i , j;
    for(i = 0; i < 9; i++){
        temp = window[i];
        for(j = i-1; j >= 0 && temp < window[j]; j--){
            window[j+1] = window[j];
        }
        window[j+1] = temp;
    }
}

void medyan (Mat& src, Mat& dst) {
    int window[9];
    for(int y = 0; y < src.rows; y++)
        for(int x = 0; x < src.cols; x++)
            dst.at<uchar>(y,x) = 0.0;
    for(int y = 1; y < src.rows - 1; y++){
        for(int x = 1; x < src.cols - 1; x++){
            // Pick up window element
            window[0] = src.at<uchar>(y - 1 ,x - 1);
            window[1] = src.at<uchar>(y, x - 1);
            window[2] = src.at<uchar>(y + 1, x - 1);
            window[3] = src.at<uchar>(y - 1, x);
            window[4] = src.at<uchar>(y, x);
            window[5] = src.at<uchar>(y + 1, x);
            window[6] = src.at<uchar>(y - 1, x + 1);
            window[7] = src.at<uchar>(y, x + 1);
            window[8] = src.at<uchar>(y + 1, x + 1);
            // sort the window to find median
            insertionSort(window);
            // assign the median to centered element of the
            dst.at<uchar>(y,x) = window[4];
        }
    }
    
}

void laplace(Mat& img, Mat& dst) {
    
    float sum, count;
    float Kernel[3][3] = {
        {0.0, -1.0, 0.0},
        {-1.0, 4.0, -1.0},
        {0.0, -1.0, 0.0}
    };
    
    //convolution operation
    for(int y = 0; y < img.rows; y++){
        for(int x = 0; x < img.cols; x++){
            sum = 0.0;
            count = 0.0;
            for(int k = -1; k <= 1;k++){
                for(int j = -1; j <=1; j++){
                    if (y-j > 0 && x-k > 0 && y-j < img.rows && x-k < img.cols) {
                        sum = sum + Kernel[j+1][k+1]*img.at<uchar>(y - j, x - k);
                        count++;
                    }
                }
            }
            dst.at<uchar>(y,x) = sum / count;
        }
    }
    
}

void sobel(Mat& img, Mat& dst) {
    
    float sum, count;
    float Kernel[3][3] = {
        {-2.0, -2.0, 0.0},
        {-2.0, 0.0, 2.0},
        {0.0, 2.0, 2.0}
    };
    
    //convolution operation
    for(int y = 0; y < img.rows; y++){
        for(int x = 0; x < img.cols; x++){
            sum = 0.0;
            count = 0.0;
            for(int k = -1; k <= 1;k++){
                for(int j = -1; j <=1; j++){
                    if (y-j > 0 && x-k > 0 && y-j < img.rows && x-k < img.cols) {
                        sum = sum + Kernel[j+1][k+1]*img.at<uchar>(y - j, x - k);
                        count++;
                    }
                }
            }
            dst.at<uchar>(y,x) = sum / count;
        }
    }
    
}


void prewitt(Mat& img, Mat& dst) {
    
    float sum, count;
    float Kernel[3][3] = {
        {-2.0, -1.0, 0.0},
        {-1.0, 0.0, 1.0},
        {0.0, 1.0, 2.0}
    };
    
    //convolution operation
    for(int y = 0; y < img.rows; y++){
        for(int x = 0; x < img.cols; x++){
            sum = 0.0;
            count = 0.0;
            for(int k = -1; k <= 1;k++){
                for(int j = -1; j <=1; j++){
                    if (y-j > 0 && x-k > 0 && y-j < img.rows && x-k < img.cols) {
                        sum = sum + Kernel[j+1][k+1]*img.at<uchar>(y - j, x - k);
                        count++;
                    }
                }
            }
            dst.at<uchar>(y,x) = sum / count;
        }
    }
    
}

void saltpapper(Mat& img, Mat& dst) {
    
    float sum, count;
    float Kernel[3][3] = {
        {1.0, 1.0, 1.0},
        {1.0, 1.0, 1.0},
        {1.0, 1.0, 1.0}
    };
    
    
    Mat saltpapperNoise = Mat::zeros(img.rows, img.cols, CV_8U);
    randu(saltpapperNoise, 0, 255);
    
    Mat black = saltpapperNoise < 10;
    Mat white = saltpapperNoise > 245;
    
    dst.setTo(0, black);
    dst.setTo(255, white);
    
    
    //convolution operation
    for(int y = 0; y < img.rows; y++){
        for(int x = 0; x < img.cols; x++){
            sum = 0.0;
            count = 0.0;
            for(int k = -1; k <= 1;k++){
                for(int j = -1; j <=1; j++){
                    if (y-j > 0 && x-k > 0 && y-j < img.rows && x-k < img.cols) {
                        sum = sum + Kernel[j+1][k+1]*img.at<uchar>(y - j, x - k);
                        count++;
                    }
                }
            }
            dst.at<uchar>(y,x) = sum / count;
        }
    }
    
}

void gaussNoise(Mat& img, Mat& dst) {
    
    float sum, count;
    float Kernel[3][3] = {
        {1.0, 1.0, 1.0},
        {1.0, 1.0, 1.0},
        {1.0, 1.0, 1.0}
    };
    
    Mat noise  = Mat(img.size(), CV_64F);
    randn(noise, 0, 0.1);
    
    normalize(img, dst, 0.0, 1.0, CV_MINMAX, CV_64F);
    
    dst = dst + noise;
    
    //normalize(dst, dst, 0, 255, CV_MINMAX, CV_8U);
    dst.convertTo(dst, 0, 255);
    
    
    //convolution operation
    for(int y = 0; y < img.rows; y++){
        for(int x = 0; x < img.cols; x++){
            sum = 0.0;
            count = 0.0;
            for(int k = -1; k <= 1;k++){
                for(int j = -1; j <=1; j++){
                    if (y-j > 0 && x-k > 0 && y-j < img.rows && x-k < img.cols) {
                        sum = sum + Kernel[j+1][k+1]*img.at<uchar>(y - j, x - k);
                        count++;
                    }
                }
            }
            dst.at<uchar>(y,x) = sum / count;
        }
    }
    
}

void rgbToHsiAndHistogram(Mat& src, Mat& dst)
{
    Mat hsi(src.rows, src.cols, src.type());
    
    float r, g, b, H = 0.0, S, I;
    
    for(int i = 0; i < src.rows; i++)
    {
        for(int j = 0; j < src.cols; j++)
        {
            b = src.at<Vec3b>(i, j)[0];
            g = src.at<Vec3b>(i, j)[1];
            r = src.at<Vec3b>(i, j)[2];
            
            I = (b + g + r) / 3;
            
            int min_val = 0;
            min_val = min(r, min(b,g));
            
            S = 1 - 3*(min_val/(b + g + r));
            if(S < 0.00001)
            {
                S = 0;
            }else if(S > 0.99999){
                S = 1;
            }
            
            if(S != 0)
            {
                H = 0.5 * ((r - g) + (r - b)) / sqrt(((r - g)*(r - g)) + ((r - b)*(g - b)));
                H = acos(H);
                
                if(b <= g)
                {
                    H = H;
                } else{
                    H = ((360 * 3.14159265) / 180.0) - H;
                }
            }
            
            hsi.at<Vec3b>(i, j)[0] = (H * 180) / 3.14159265;
            hsi.at<Vec3b>(i, j)[1] = S*100;
            hsi.at<Vec3b>(i, j)[2] = I;
        }
    }
    
    
    // Generate the histogram
    int histogram[256];
    imhist(hsi, histogram);
    
    // Caluculate the size of image
    int size = hsi.rows * hsi.cols;
    float alpha = 255.0/size;
    
    
    
    // Generate cumulative frequency histogram
    int cumhistogram[256];
    cumhist(histogram,cumhistogram );
    
    // Scale the histogram
    int Sk[256];
    for(int i = 0; i < 256; i++)
    {
        Sk[i] = cvRound((float)cumhistogram[i] * alpha);
    }
    
    
    dst = hsi.clone();
    
    // Eski kod
    for(int y = 0; y < src.rows; y++)
        for(int x = 0; x < src.cols; x++)
            dst.at<Vec3b>(y,x)[2] = saturate_cast<uchar>(Sk[hsi.at<Vec3b>(y,x)[2]]);
    
    
}


int reflect(int M, int x)
{
    if(x < 0)
    {
        return -x - 1;
    }
    if(x >= M)
    {
        return 2*M - x - 1;
    }

    return x;
}

void gaussBlur(Mat& src, Mat& dst)
{
    
    Mat temp;
    float sum, x1, y1;
    double coeffs[] = {0.0545, 0.2442, 0.4026, 0.2442, 0.0545};
   
    dst = src.clone();
    temp = src.clone();
    
    for(int y = 0; y < src.rows; y++){
        for(int x = 0; x < src.cols; x++){
            sum = 0.0;
            for(int i = -2; i <= 2; i++){
                y1 = reflect(src.rows, y - i);
                sum = sum + coeffs[i + 2]*src.at<uchar>(y1, x);
            }
            temp.at<uchar>(y,x) = sum;
        }
    }
    
    
    for(int y = 0; y < src.rows; y++){
        for(int x = 0; x < src.cols; x++){
            sum = 0.0;
            for(int i = -2; i <= 2; i++){
                x1 = reflect(src.cols, x - i);
                sum = sum + coeffs[i + 2]*temp.at<uchar>(y, x1);
            }
            dst.at<uchar>(y,x) = sum;
        }
    }
}

//--------------------------------------------------------

inline uchar Clamp(int n)
{
    n = n>255 ? 255 : n;
    return n<0 ? 0 : n;
}

void AddGaussianNoise(const Mat& mSrc, Mat &mDst)
{
    
    Mat mGaussian_noise = Mat(mSrc.size(),CV_16SC3);
    randn(mGaussian_noise,0, 10);
    
    for (int Rows = 0; Rows < mSrc.rows; Rows++)
    {
        for (int Cols = 0; Cols < mSrc.cols; Cols++)
        {
            Vec3b Source_Pixel= mSrc.at<Vec3b>(Rows,Cols);
            Vec3b &Des_Pixel= mDst.at<Vec3b>(Rows,Cols);
            Vec3s Noise_Pixel= mGaussian_noise.at<Vec3s>(Rows,Cols);
            
            for (int i = 0; i < 3; i++)
            {
                int Dest_Pixel= Source_Pixel.val[i] + Noise_Pixel.val[i];
                Des_Pixel.val[i]= Clamp(Dest_Pixel);
            }
        }
    }
    
}

bool AddGaussianNoise_Opencv(const Mat mSrc, Mat &mDst,double Mean=0.0, double StdDev=10.0)
{
    if(mSrc.empty())
    {
        cout<<"[Error]! Input Image Empty!";
        return 0;
    }
    Mat mSrc_16SC;
    Mat mGaussian_noise = Mat(mSrc.size(),CV_16SC3);
    randn(mGaussian_noise,Scalar::all(Mean), Scalar::all(StdDev));
    
    mSrc.convertTo(mSrc_16SC,CV_16SC3);
    addWeighted(mSrc_16SC, 1.0, mGaussian_noise, 1.0, 0.0, mSrc_16SC);
    mSrc_16SC.convertTo(mDst,mSrc.type());
    
    return true;
}

+(UIImage *) makeGrayImage:(UIImage *) image number:(int) filterNumber{
    
    Mat img;
    UIImageToMat(image, img);
    
    
    if (filterNumber == 13 || filterNumber == 14) {
        cvtColor( img, img, 1);
    } else {
        cvtColor( img, img, CV_BGR2GRAY );
    }
    
    
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"aa" ofType:@"jpeg"];
    //const char * cpath = [path cStringUsingEncoding:NSUTF8StringEncoding];
    //Mat img = imread( cpath, CV_LOAD_IMAGE_GRAYSCALE );
    
    int erosion_size = 6;
    Mat element = getStructuringElement(cv::MORPH_CROSS,
                                        cv::Size(2 * erosion_size + 1, 2 * erosion_size + 1),
                                        cv::Point(erosion_size, erosion_size) );
    
    
    Mat filtre, genis, acma, kapama, asindir;
    
    
    // Dönüşüm
    Point2f pt(img.cols / 2., img.rows / 2.);
    Mat r = getRotationMatrix2D(pt, 45, 1.0);
  
    
    Mat dst = img.clone();
    
    switch (filterNumber) {
        case 0:
            kontrastgerme1(dst, 70, 180);
            break;
        case 1:
            esikleme(dst, 90);
            break;
        case 2:
            negatif(dst);
            break;
        case 3:
            //us alma
            GammaCorrection(dst, dst, 0.5);
            break;
        case 4:
            logaritma(dst, 15);
            break;
        case 5:
            BitWise(dst, dst, 128);
            break;
        case 6:
            histogram(img, dst);
            break;
        case 7:
            ortalama(img, dst);
            break;
        case 8:
            medyan(img, dst);
            break;
        case 9:
            laplace(img, dst);
            break;
        case 10:
            sobel(img, dst);
            break;
        case 11:
            gaussNoise(img, dst);
            break;
        case 12:
            saltpapper(img, dst);
            break;
        case 13:
            rgbToHsiAndHistogram(img, dst); // eksik
            break;
        case 14:
            AddGaussianNoise_Opencv(img,dst,0,10.0);
            break;
        case 15:
            Canny( img, dst, 10,350);
        case 16:
            erode(img,dst,element); // aşındırma
            break;
        case 17:
            dilate(img,dst,element); // genişletme
            break;
        case 18: // kapama
            threshold(img, dst, 128, 255, CV_THRESH_BINARY); 
            dilate(dst, genis, filtre, Point2f(-1, -1), 2, 0, Scalar(255, 255, 255));
            morphologyEx(genis, acma, MORPH_OPEN, filtre);
            dst = acma.clone();
            break;
        case 19: // açma
            threshold(img, dst, 128, 255, CV_THRESH_BINARY);
            erode(dst, genis, filtre, Point2f(-1, -1), 2, 0, Scalar(255, 255, 255));
            morphologyEx(genis, acma, MORPH_OPEN, filtre);
            dst = acma.clone();
            break;
        case 20:
            prewitt(img, dst);
            break;
        case 21:
            gaussBlur(img, dst);
            break;
        case 22:
            warpAffine(img, dst, r, Size2f(img.cols, img.rows));
            break;
        default:
            break;
    }
    
    return  MatToUIImage(dst);
}

@end
