#include "mex.h"
#include <vector>
#include <map>
#include <set>
#include <iostream>

using namespace std;

/* The gateway function */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    if (nrhs != 3)
    {
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:nrhs", "Two inputs required.");
    }
    if (nlhs != 1)
    {
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:nlhs", "One output required.");
    }


    //传入
    vector<vector<double>> cluster_1;
    vector<vector<double>> cluster_2;
    double th;
    double* dataCursor;
    dataCursor = mxGetPr(prhs[2]);
    th = *dataCursor;

    dataCursor = mxGetPr(prhs[0]);
    int mrows = mxGetM(prhs[0]);   //获得矩阵的行
    int ncols = mxGetN(prhs[0]);   //获得矩阵的列
  

    cout << th << endl;

    cout << mrows << "*" << ncols <<endl;

    cluster_1.resize(mrows); //初始化
    for (int i = 0; i < mrows; i++)
    {
        cluster_1[i].resize(ncols);
    }

    for (int i = 0; i < mrows; i++)
    {
        for (int j = 0; j < ncols; j++)
        {
            cluster_1[i][j] = dataCursor[j * mrows + i]; //拷贝矩阵的元素到vector of vector
        }
    }

    dataCursor = mxGetPr(prhs[1]);   //得到输入矩阵的第一个元素的指针
    mrows = mxGetM(prhs[1]);         //获得矩阵的行
    ncols = mxGetN(prhs[1]);         //获得矩阵的列

    cluster_2.resize(mrows); //初始化
    for (int i = 0; i < mrows; i++)
    {
        cluster_2[i].resize(ncols);
    }

    for (int i = 0; i < mrows; i++)
    {
        for (int j = 0; j < ncols; j++)
        {
            cluster_2[i][j] = dataCursor[j * mrows + i]; //拷贝矩阵的元素到vector of vector
        }
    }


    

    //处理：real_matches = f(cluster_1, cluster_2)
    //建立cluster匹配关系
    map<double, vector<vector<double>>> cells1, cells2;
    vector<vector<double>> real_matches;
    for(int i = 0; i < mrows; i++){
        if (cells1.find(cluster_1[i][3]) == cells1.end()) {
            cells1[cluster_1[i][3]] = vector<vector<double>>();
        }
        if (cells2.find(cluster_2[i][3]) == cells2.end()) {
            cells2[cluster_2[i][3]] = vector<vector<double>>();
        }
        cells1[cluster_1[i][3]].push_back(cluster_1[i]);
        cells2[cluster_2[i][3]].push_back(cluster_2[i]);
    }

    for(auto i = cells1.begin(); i != cells1.end(); ++i){
        if(i->first == 0.0){
            continue;
        }
        for(auto j = cells2.begin(); j != cells2.end(); ++j){
            if(j->first == 0.0){
                continue;
            }
            vector<vector<double>> matches1 = i->second;
            vector<vector<double>> matches2 = j->second;
            vector<vector<double>> com_matches;

            for(int m = 0; m < matches1.size(); ++m){
                for(int n = 0; n < matches2.size(); ++n){
                    if(matches1[m][0] == matches2[n][0]){
                        vector<double> points;
                        points.insert(points.end(), matches1[m].begin(), matches1[m].end()-1);
                        points.insert(points.end(), matches2[n].begin()+1, matches2[n].end()-1);
                        com_matches.push_back(points);
                    }
                }
            }
            cout << double(com_matches.size())/matches1.size() << endl;
            if(double(com_matches.size())/matches1.size() >= th || double(com_matches.size())/matches2.size() >= th){
                real_matches.insert(real_matches.end(), com_matches.begin(), com_matches.end());
            }

        }
    }
    cout << cells1.size() << cells2.size() << endl;

    for (int i = 0; i < real_matches[0].size(); i++) {
        cout << real_matches[0][i] << " ";
    }
    //传出
    double *z;
    plhs[0] = mxCreateDoubleMatrix(real_matches.size(), 1, mxREAL); //第一个输出是一个5*6的矩阵
    z = mxGetPr(plhs[0]);                         //获得矩阵的第一个元素的指针
    for (int i = 0; i < real_matches.size(); i++)
    {
            z[i] = real_matches[i][0]; //指针访问矩阵是列优先的，请自己循环程序和分析输出结果
    }
}
