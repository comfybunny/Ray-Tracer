public abstract class Shape{
  
  private Surface surface;
  private XMatrix3D ctm;
  
  abstract IntersectionObject intersects(Ray tempRay);
    
  abstract PVector shapeNormal(Point hitPoint);
  
  abstract String debug();
  
  public void addSurface(Surface surface){
    this.surface = surface;
  }
  
  public Surface getSurface(){
    return surface;
  }
  
  public void addCTM(XMatrix3D toAdd){
    
  }
}