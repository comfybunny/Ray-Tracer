public class PointLight{
  
  private Point location;
  private Color lightColor;
  
  public PointLight(Point location, Color lightColor){
    this.location = location;
    this.lightColor = lightColor;
  }
  
  public Point getPoint(){
    return location;
  }
  
  public Color getColor(){
    return lightColor;
  }
  
}