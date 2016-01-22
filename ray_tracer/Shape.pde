public abstract class Shape{
  
  private Surface surface;
  
  abstract float intersects(Ray tempRay);
  
  abstract Point hitPoint(Ray ray, float time);
  
  abstract PVector shapeNormal(Point hitPoint);
  
  public void addSurface(Surface surface){
    this.surface = surface;
  }
  
  public Surface getSurface(){
    return surface;
  }
  
}