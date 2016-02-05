public class XMatrix3D{
  
  private float[][] matrix;
  
  public XMatrix3D(){
    matrix = new float[4][4];
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
      if(info[1] == 1){
        matrix[0][0] = 1;
        matrix[1][1] = cos(theta);
        matrix[1][2] = -sin(theta);
        matrix[2][1] = sin(theta);
        matrix[2][2] = cos(theta);
      }
      else if(info[2] == 1){
        matrix[0][0] = cos(theta);
        matrix[0][2] = sin(theta);
        matrix[1][1] = 1;
        matrix[2][0] = -sin(theta);
        matrix[2][2] = cos(theta);
      }
      else if(info[3] == 1){
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
  
  public void setMatrix(int row, int col, float value){
    matrix[row][col] = value;
  }
  
  public void printDebug(){
    for(int i= 0; i< 4; i++){
      for(int j = 0; j < 4; j++){
        print(matrix[i][j] + "\t");
      }
      println();
    }
  }
}