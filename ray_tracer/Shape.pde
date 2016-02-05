public abstract class Shape{
  
  private Surface surface;
  
  abstract float intersects(Ray tempRay);
    
  abstract PVector shapeNormal(Point hitPoint);
  
  abstract String debug();
  
  public void addSurface(Surface surface){
    this.surface = surface;
  }
  
  public Surface getSurface(){
    return surface;
  }
  
}