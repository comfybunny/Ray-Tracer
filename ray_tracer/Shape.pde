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
  
  public Point getCentroid(){
    return null;
  }
  
  public IntersectionObject intersectPrint(Ray ray){
    return null;
  }
  
  public float P0X(){
    return -100;
  }
  public float P1X(){
    return -100;
  }
  
  public void includePoint(Point min, Point max){
  }
  
  public void balance(int lols){
  }
  
  public Box getBox(){
    return null;
  }
  
  public int getSize(){
    return 0;
  }
  
  public ArrayList<Shape> getShapes(){
    return null;
  }
  
  public Shape getLeft(){
    return null;
  }
  public Shape getRight(){
    return null;
  }
}