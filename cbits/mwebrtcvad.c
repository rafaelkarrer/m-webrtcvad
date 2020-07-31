/*==========================================================
 * arrayProduct.c - example in MATLAB External Interfaces
 *
 * Multiplies an input scalar (multiplier) 
 * times a 1xN matrix (inMatrix)
 * and outputs a 1xN matrix (outMatrix)
 *
 * The calling syntax is:
 *
 *		outMatrix = arrayProduct(multiplier, inMatrix)
 *
 * This is a MEX-file for MATLAB.
 * Copyright 2007-2012 The MathWorks, Inc.
 *
 *========================================================*/

#include "mex.h"

#include "webrtc\common_audio\vad\include\webrtc_vad.h"

/* The computational routine */
void arrayProduct(double x, double *y, double *z, mwSize n)
{
    mwSize i;
    /* multiply each element y by x */
    for (i=0; i<n; i++) {
        z[i] = x * y[i];
    }
}

/* The gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
    double multiplier;              /* input scalar */
    double *inMatrix;               /* 1xN input matrix */
    size_t ncols;                   /* size of matrix */
    double *outMatrix;              /* output matrix */

    /* check for proper number of arguments */
    if( !mxIsChar(prhs[0]) ) {
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:nrhs","First input must be string");
    }
    if ( !strcmp(prhs[0], "Init") ) {
       int x = 1; 
    } else if ( !strcmp(prhs[0], "Set_Mode") ) {
        int x = 2;
    } else if ( !strcmp(prhs[0], "Process") ) {
        int x = 3;
    } else {
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:nrhs","First argument must be one of the following string: 'Init', 'Set_Mode', 'Process'.");
    }
    if(nrhs!=2) {
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:nrhs","Two inputs required.");
    }
    if(nlhs!=1) {
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:nlhs","One output required.");
    }
    /* make sure the first input argument is scalar */
    if( !mxIsDouble(prhs[0]) || 
         mxIsComplex(prhs[0]) ||
         mxGetNumberOfElements(prhs[0])!=1 ) {
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:notScalar","Input multiplier must be a scalar.");
    }
    
    /* make sure the second input argument is type double */
    if( !mxIsDouble(prhs[1]) || 
         mxIsComplex(prhs[1])) {
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:notDouble","Input matrix must be type double.");
    }
    
    /* check that number of rows in second input argument is 1 */
    if(mxGetM(prhs[1])!=1) {
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:notRowVector","Input must be a row vector.");
    }
    
    /* get the value of the scalar input  */
    multiplier = mxGetScalar(prhs[0]);

    /* create a pointer to the real data in the input matrix  */
    #if MX_HAS_INTERLEAVED_COMPLEX
    inMatrix = mxGetDoubles(prhs[1]);
    #else
    inMatrix = mxGetPr(prhs[1]);
    #endif

    /* get dimensions of the input matrix */
    ncols = mxGetN(prhs[1]);

    /* create the output matrix */
    plhs[0] = mxCreateDoubleMatrix(1,(mwSize)ncols,mxREAL);

    /* get a pointer to the real data in the output matrix */
    #if MX_HAS_INTERLEAVED_COMPLEX
    outMatrix = mxGetDoubles(plhs[0]);
    #else
    outMatrix = mxGetPr(plhs[0]);
    #endif

    const int kModes[] = {0, 1, 2, 3};
    const int kRates[] = {8000, 12000, 16000, 24000, 32000, 48000};
    const size_t kRatesSize = sizeof(kRates) / sizeof(*kRates);

    // Frame lengths we support.
    const size_t kMaxFrameLength = 1440;
    const size_t kFrameLengths[] = {80, 120, 160, 240, 320, 480, 640, 960, kMaxFrameLength};
    const size_t kFrameLengthsSize = sizeof(kFrameLengths) / sizeof(*kFrameLengths);

    // Construct a speech signal that will trigger the VAD in all modes. It is
    // known that (i * i) will wrap around, but that doesn't matter in this case.
    int16_t speech[1440];
    for (size_t i = 0; i < kMaxFrameLength; i++) {
        speech[i] = (int16_t)(i * i);
    }
    VadInst* handle = WebRtcVad_Create();
    WebRtcVad_Init(handle);
    WebRtcVad_set_mode(handle, kModes[0]);

    WebRtcVad_Process(handle, kRates[0], speech, kFrameLengths[0]);

    WebRtcVad_Free(handle);
    mexErrMsgIdAndTxt("MyToolbox:arrayProduct:notScalar","XXXXXXXXXXXXXXXXX");
    /* call the computational routine */
    arrayProduct(multiplier,inMatrix,outMatrix,(mwSize)ncols);
}
