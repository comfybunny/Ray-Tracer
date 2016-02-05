public class MatrixStack{
  
  private ArrayList<XMatrix3D> stack;
  
  public MatrixStack(){
    stack = new ArrayList<XMatrix3D>();
    stack.add(new XMatrix3D("identity"));
  }
  
  public void push(){
    XMatrix3D ctm = getCTM();
    XMatrix3D newMatrix = new XMatrix3D();
    //println("PUSH HERE");
    //ctm.printDebug();
    newMatrix.deepCopy(ctm);
    stack.add(newMatrix);
  }
  
  public void pop(){
    if(stack.size()==1){
      print("ERROR! Pop attempted when only one matrix on stack.");
    }
    else{
      stack.remove(stack.size()-1);
    }
  }
  
  public XMatrix3D getCTM(){
    return stack.get(stack.size()-1);
  }
  
  public void addTranslate(float tx, float ty, float tz){
    float[] matrixInfo = new float[3];
    matrixInfo[0] = tx;
    matrixInfo[1] = ty;
    matrixInfo[2] = tz;
    XMatrix3D translateMatrix = new XMatrix3D("translate", matrixInfo);
    getCTM().rightMultiply(translateMatrix);
  }
  
  public void addScale(float sx, float sy, float sz){
    float[] matrixInfo = new float[3];
    matrixInfo[0] = sx;
    matrixInfo[1] = sy;
    matrixInfo[2] = sz;
    XMatrix3D scaleMatrix = new XMatrix3D("scale", matrixInfo);
    getCTM().rightMultiply(scaleMatrix);
  }
  
  public void addRotate(float angleDegrees, float xAxis, float yAxis, float zAxis){
    float[] matrixInfo = new float[4];
    matrixInfo[0] = angleDegrees;
    matrixInfo[1] = xAxis;
    matrixInfo[2] = yAxis;
    matrixInfo[3] = zAxis;
    XMatrix3D rotateMatrix = new XMatrix3D("rotate", matrixInfo);
    //rotateMatrix.printDebug();
    getCTM().rightMultiply(rotateMatrix);
  }
}