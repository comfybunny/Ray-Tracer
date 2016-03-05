public class IntersectionObject{
  float time;
  PVector surfaceNormal;
  public IntersectionObject(float time, PVector surfaceNormal){
    this.time = time;
    this.surfaceNormal = surfaceNormal;
  }
  
  public float getTime(){
    return time;
  }
  public PVector getSurfaceNormal(){
    return surfaceNormal;
  }
  public void setSurfaceNormal(PVector newNormal){
    surfaceNormal = newNormal;
  }
}