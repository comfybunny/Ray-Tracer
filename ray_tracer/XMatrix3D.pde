public class XMatrix3D{
  
  private float[][] matrix;
  
  public XMatrix3D(){
    matrix = new float[4][4];
  }
  
  public XMatrix3D(float aa, float ab, float ac, float ad, float ba, float bb, float bc, float bd, float ca, float cb, float cc, float cd, float da, float db, float dc, float dd){
    matrix = new float[4][4];
    matrix[0][0] = aa;
    matrix[0][1] = ab;
    matrix[0][2] = ac;
    matrix[0][3] = ad;
    matrix[1][0] = ba;
    matrix[1][1] = bb;
    matrix[1][2] = bc;
    matrix[1][3] = bd;
    matrix[2][0] = ca;
    matrix[2][1] = cb;
    matrix[2][2] = cc;
    matrix[2][3] = cd;
    matrix[3][0] = da;
    matrix[3][1] = db;
    matrix[3][2] = dc;
    matrix[3][3] = dd;
  }
  
  public XMatrix3D(String type){
    matrix = new float[4][4];
    if(type.equals("identity")){
      matrix[0][0] = 1;
      matrix[1][1] = 1;
      matrix[2][2] = 1;
      matrix[3][3] = 1;
    }
  }
  
  public XMatrix3D(String type, float[] info){
    matrix = new float[4][4];
    if(type.equals("translate")){
      matrix[0][0] = 1;
      matrix[1][1] = 1;
      matrix[2][2] = 1;
      matrix[3][3] = 1;
      
      matrix[0][3] = info[0];
      matrix[1][3] = info[1];
      matrix[2][3] = info[2];
      
    }
    else if(type.equals("scale")){
      matrix[0][0] = info[0];
      matrix[1][1] = info[1];
      matrix[2][2] = info[2];
      matrix[3][3] = 1;
    }
    // The rotation matrix rotates the angle in degrees counter-clockwise about the axis (x,y,z). 
    // The counter-clockwise rotation is looking from position (x,y,z) towards the origin.
    else if(type.equals("rotate")){
      float theta = info[0]*(PI/180.0);
      matrix[3][3] = 1;
      // x axis rotation
      if(info[1] == 1 && info[2] == 0 && info[3] == 0){
        matrix[0][0] = 1;
        matrix[1][1] = cos(theta);
        matrix[1][2] = -sin(theta);
        matrix[2][1] = sin(theta);
        matrix[2][2] = cos(theta);
      }
      else if(info[1] == 0 && info[2] == 1 && info[3] == 0){
        matrix[0][0] = cos(theta);
        matrix[0][2] = sin(theta);
        matrix[1][1] = 1;
        matrix[2][0] = -sin(theta);
        matrix[2][2] = cos(theta);
      }
      else if(info[1] == 0 && info[2] == 0 && info[3] == 1){
        matrix[0][0] = cos(theta);
        matrix[0][1] = -sin(theta);
        matrix[1][0] = sin(theta);
        matrix[1][1] = cos(theta);
        matrix[2][2] = 1;
      }
      else{
        println("MATRIX ROTATION NOT SUPPORTED");
      }
    }
  }
  
  public float[][] getMatrix(){
    return matrix;
  }
  
  public void deepCopy(XMatrix3D toCopy){
    float[][] copy = toCopy.getMatrix();
    for(int i = 0; i < 4; i++){
      for(int j = 0; j < 4; j++){
        matrix[i][j] = copy[i][j];
      }
    }
  }
  
  public void rightMultiply(XMatrix3D rightMultMatrix){
    
    float[][] matrixRight = rightMultMatrix.getMatrix();
    
    float[][] tempHold = new float[4][4];
    
    tempHold[0][0] = matrix[0][0]*matrixRight[0][0] + matrix[0][1]*matrixRight[1][0] + matrix[0][2]*matrixRight[2][0] + matrix[0][3]*matrixRight[3][0];
    tempHold[0][1] = matrix[0][0]*matrixRight[0][1] + matrix[0][1]*matrixRight[1][1] + matrix[0][2]*matrixRight[2][1] + matrix[0][3]*matrixRight[3][1];
    tempHold[0][2] = matrix[0][0]*matrixRight[0][2] + matrix[0][1]*matrixRight[1][2] + matrix[0][2]*matrixRight[2][2] + matrix[0][3]*matrixRight[3][2];
    tempHold[0][3] = matrix[0][0]*matrixRight[0][3] + matrix[0][1]*matrixRight[1][3] + matrix[0][2]*matrixRight[2][3] + matrix[0][3]*matrixRight[3][3];
    
    tempHold[1][0] = matrix[1][0]*matrixRight[0][0] + matrix[1][1]*matrixRight[1][0] + matrix[1][2]*matrixRight[2][0] + matrix[1][3]*matrixRight[3][0];
    tempHold[1][1] = matrix[1][0]*matrixRight[0][1] + matrix[1][1]*matrixRight[1][1] + matrix[1][2]*matrixRight[2][1] + matrix[1][3]*matrixRight[3][1];
    tempHold[1][2] = matrix[1][0]*matrixRight[0][2] + matrix[1][1]*matrixRight[1][2] + matrix[1][2]*matrixRight[2][2] + matrix[1][3]*matrixRight[3][2];
    tempHold[1][3] = matrix[1][0]*matrixRight[0][3] + matrix[1][1]*matrixRight[1][3] + matrix[1][2]*matrixRight[2][3] + matrix[1][3]*matrixRight[3][3];
    
    tempHold[2][0] = matrix[2][0]*matrixRight[0][0] + matrix[2][1]*matrixRight[1][0] + matrix[2][2]*matrixRight[2][0] + matrix[2][3]*matrixRight[3][0];
    tempHold[2][1] = matrix[2][0]*matrixRight[0][1] + matrix[2][1]*matrixRight[1][1] + matrix[2][2]*matrixRight[2][1] + matrix[2][3]*matrixRight[3][1];
    tempHold[2][2] = matrix[2][0]*matrixRight[0][2] + matrix[2][1]*matrixRight[1][2] + matrix[2][2]*matrixRight[2][2] + matrix[2][3]*matrixRight[3][2];
    tempHold[2][3] = matrix[2][0]*matrixRight[0][3] + matrix[2][1]*matrixRight[1][3] + matrix[2][2]*matrixRight[2][3] + matrix[2][3]*matrixRight[3][3];
    
    tempHold[3][0] = matrix[3][0]*matrixRight[0][0] + matrix[3][1]*matrixRight[1][0] + matrix[3][2]*matrixRight[2][0] + matrix[3][3]*matrixRight[3][0];
    tempHold[3][1] = matrix[3][0]*matrixRight[0][1] + matrix[3][1]*matrixRight[1][1] + matrix[3][2]*matrixRight[2][1] + matrix[3][3]*matrixRight[3][1];
    tempHold[3][2] = matrix[3][0]*matrixRight[0][2] + matrix[3][1]*matrixRight[1][2] + matrix[3][2]*matrixRight[2][2] + matrix[3][3]*matrixRight[3][2];
    tempHold[3][3] = matrix[3][0]*matrixRight[0][3] + matrix[3][1]*matrixRight[1][3] + matrix[3][2]*matrixRight[2][3] + matrix[3][3]*matrixRight[3][3];
    
    matrix = tempHold;
  }
  
  public float[] vectorMultiply(float[] toMultiply){
    float[] toReturn = new float[4];
    toReturn[0] = matrix[0][0]*toMultiply[0] + matrix[0][1]*toMultiply[1] + matrix[0][2]*toMultiply[2] + matrix[0][3]*toMultiply[3]; 
    toReturn[1] = matrix[1][0]*toMultiply[0] + matrix[1][1]*toMultiply[1] + matrix[1][2]*toMultiply[2] + matrix[1][3]*toMultiply[3]; 
    toReturn[2] = matrix[2][0]*toMultiply[0] + matrix[2][1]*toMultiply[1] + matrix[2][2]*toMultiply[2] + matrix[2][3]*toMultiply[3]; 
    toReturn[3] = matrix[3][0]*toMultiply[0] + matrix[3][1]*toMultiply[1] + matrix[3][2]*toMultiply[2] + matrix[3][3]*toMultiply[3]; 
    return toReturn;
  }
  
  public PVector PVectorMultiply(PVector toMultiply){
    PVector toReturn = new PVector();
    toReturn.x = matrix[0][0]*toMultiply.x + matrix[0][1]*toMultiply.y + matrix[0][2]*toMultiply.z; 
    toReturn.y = matrix[1][0]*toMultiply.x + matrix[1][1]*toMultiply.y + matrix[1][2]*toMultiply.z;
    toReturn.z = matrix[2][0]*toMultiply.x + matrix[2][1]*toMultiply.y + matrix[2][2]*toMultiply.z;
    return toReturn;
  }
  
  public PVector multiplyAdjoint(PVector toMultiply){
    PVector toReturn = new PVector();
    toReturn.x = matrix[0][0]*toMultiply.x + matrix[1][0]*toMultiply.y + matrix[2][0]*toMultiply.z; 
    toReturn.y = matrix[0][1]*toMultiply.x + matrix[1][1]*toMultiply.y + matrix[2][1]*toMultiply.z;
    toReturn.z = matrix[0][2]*toMultiply.x + matrix[1][2]*toMultiply.y + matrix[2][2]*toMultiply.z;
    return toReturn;
  }
  
  public void setMatrix(int row, int col, float value){
    matrix[row][col] = value;
  }
  
  public void printDebug(){
    for(int i= 0; i < 4; i++){
      for(int j = 0; j < 4; j++){
        print(matrix[i][j] + "\t\t");
      }
      println();
    }
  }
  
  public XMatrix3D getInverse(){
    float a11 = matrix[0][0];
    float a12 = matrix[0][1];
    float a13 = matrix[0][2];
    float a14 = matrix[0][3];
    float a21 = matrix[1][0];
    float a22 = matrix[1][1];
    float a23 = matrix[1][2];
    float a24 = matrix[1][3];
    float a31 = matrix[2][0];
    float a32 = matrix[2][1];
    float a33 = matrix[2][2];
    float a34 = matrix[2][3];
    float a41 = matrix[3][0];
    float a42 = matrix[3][1];
    float a43 = matrix[3][2];
    float a44 = matrix[3][3];
    
    float det = a11*a22*a33*a44 + a11*a23*a34*a42 + a11*a24*a32*a43
              + a12*a21*a34*a43 + a12*a23*a31*a44 + a12*a24*a33*a41
              + a13*a21*a32*a44 + a13*a22*a34*a41 + a13*a24*a31*a42
              + a14*a21*a33*a42 + a14*a22*a31*a43 + a14*a23*a32*a41
              - a11*a22*a34*a43 - a11*a23*a32*a44 - a11*a24*a33*a42
              - a12*a21*a33*a44 - a12*a23*a34*a41 - a12*a24*a31*a43
              - a13*a21*a34*a42 - a13*a22*a31*a44 - a13*a24*a32*a41
              - a14*a21*a32*a43 - a14*a22*a33*a41 - a14*a23*a31*a42;
              
    float b11 = a22*a33*a44 + a23*a34*a42 + a24*a32*a43 - a22*a34*a43 - a23*a32*a44 - a24*a33*a42;
    float b12 = a12*a34*a43 + a13*a32*a44 + a14*a33*a42 - a12*a33*a44 - a13*a34*a42 - a14*a32*a43;
    float b13 = a12*a23*a44 + a13*a24*a42 + a14*a22*a43 - a12*a24*a43 - a13*a22*a44 - a14*a23*a42;
    float b14 = a12*a24*a33 + a13*a22*a34 + a14*a23*a32 - a12*a23*a34 - a13*a24*a32 - a14*a22*a33;
    float b21 = a21*a34*a43 + a23*a31*a44 + a24*a33*a41 - a21*a33*a44 - a23*a34*a41 - a24*a31*a43;
    float b22 = a11*a33*a44 + a13*a34*a41 + a14*a31*a43 - a11*a34*a43 - a13*a31*a44 - a14*a33*a41;
    float b23 = a11*a24*a43 + a13*a21*a44 + a14*a23*a41 - a11*a23*a44 - a13*a24*a41 - a14*a21*a43;
    float b24 = a11*a23*a34 + a13*a24*a31 + a14*a21*a33 - a11*a24*a33 - a13*a21*a34 - a14*a23*a31;
    float b31 = a21*a32*a44 + a22*a34*a41 + a24*a31*a42 - a21*a34*a42 - a22*a31*a44 - a24*a32*a41;
    float b32 = a11*a34*a42 + a12*a31*a44 + a14*a32*a41 - a11*a32*a44 - a12*a34*a41 - a14*a31*a42;
    float b33 = a11*a22*a44 + a12*a24*a41 + a14*a21*a42 - a11*a24*a42 - a12*a21*a44 - a14*a22*a41;
    float b34 = a11*a24*a32 + a12*a21*a34 + a14*a22*a31 - a11*a22*a34 - a12*a24*a31 - a14*a21*a32;
    float b41 = a21*a33*a42 + a22*a31*a43 + a23*a32*a41 - a21*a32*a43 - a22*a33*a41 - a23*a31*a42;
    float b42 = a11*a32*a43 + a12*a33*a41 + a13*a31*a42 - a11*a33*a42 - a12*a31*a43 - a13*a32*a41;
    float b43 = a11*a23*a42 + a12*a21*a43 + a13*a22*a41 - a11*a22*a43 - a12*a23*a41 - a13*a21*a42;
    float b44 = a11*a22*a33 + a12*a23*a31 + a13*a21*a32 - a11*a23*a32 - a12*a21*a33 - a13*a22*a31;

    /**
    println(b11);
    println(b12);
    println(b13);
    println(b14);
    println(b21);
    println(b22);
    println(b23);
    println(b24);
    println(b31);
    println(b32);
    println(b33);
    println(b34);
    println(b41);
    println(b42);
    println(b43);
    println(b44);
    **/
    
    return new XMatrix3D(b11/det, b12/det, b13/det, b14/det, b21/det, b22/det, b23/det, b24/det, b31/det, b32/det, b33/det, b34/det, b41/det, b42/det, b43/det, b44/det);
  }
}