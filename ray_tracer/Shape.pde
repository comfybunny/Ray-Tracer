public abstract class Shape{
  
  private DiffuseSurface diffuseSurface;
  
  abstract float intersects(Ray tempRay);
  
  abstract Point hitPoint(Ray ray, float time);
  
  abstract PVector shapeNormal(Point hitPoint);
  
  public void addDiffuseSurface(DiffuseSurface diffuseSurface){
    this.diffuseSurface = diffuseSurface;
  }
  
  public DiffuseSurface getDiffuseSurface(){
    return diffuseSurface;
  }
  
}