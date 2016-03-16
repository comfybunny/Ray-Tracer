public abstract class Shape{
  
  private Surface surface;
  //private Box box;
  
  abstract IntersectionObject intersects(Ray tempRay);
    
  abstract PVector shapeNormal(Point hitPoint);
  
  abstract String debug();
  
  public void addSurface(Surface surface){
    this.surface = surface;
  }
  
  public Surface getSurface(){
    return surface;
  }
  
  public Point minPoint(){
    return new Point();
  }
  
  public Point maxPoint(){
    return new Point();
  }
  public Box getBox(){
    return null;
  }
  public Point getCentroid(){
    return null;
  }
}