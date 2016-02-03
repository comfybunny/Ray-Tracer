public class MatrixStack{
  
  private ArrayList<XMatrix3D> stack;
  
  public MatrixStack(){
    stack = new ArrayList<XMatrix3D>();
    stack.add(new XMatrix3D("identity"));
  }
  
  public void push(){
    XMatrix3D ctm = getCTM();
    XMatrix3D newMatrix = new XMatrix3D();
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
  
  public void translate(float tx, float ty, float tz){
    float[] matrixInfo = new float[3];
    matrixInfo[0] = tx;
    matrixInfo[1] = ty;
    matrixInfo[2] = tz;
    XMatrix3D translateMatrix = new XMatrix3D("translate", matrixInfo);
    getCTM().rightMultiply(translateMatrix);
  }
  
  
}