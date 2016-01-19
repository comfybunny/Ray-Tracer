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
  
}