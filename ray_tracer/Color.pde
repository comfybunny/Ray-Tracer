public class Color{
  private float R;
  private float G;
  private float B;
  
  public Color(){
    R = 0;
    G = 0;
    B = 0;
  }
  
  public Color(float R, float G, float B){
    this.R = R;
    this.G = G;
    this.B = B;
  }
  
  public float getR(){
    return R;
  }
  public float getG(){
    return G;
  }

  public float getB(){
    return B;
  }
  
  public void setR(float R){
    this.R = R;
  }  
  
  public void setG(float G){
    this.G = G;
  }
  
  public void setB(float B){
    this.B = B;
  }
  
  public void setRGB(float R, float G, float B){
    this.R = R;
    this.G = G;
    this.B = B;
  }
  
  public void add(Color durp){
    R += durp.getR();
    G += durp.getG();
    B += durp.getB();
  }
  
  public String toString(){
    return "R: " + R + "\tG: " + G + "\tB: " + B;
  }
  
  // returns new Color object
  public Color dotProduct(Color b){
    return new Color(R*b.getR(), G*b.getG(), B*b.getB());
  }
  
  public void multiply(float factor){
    R = R*factor;
    G = G*factor;
    B = B*factor;
  }
  
}