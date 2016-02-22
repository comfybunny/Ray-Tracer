public class Light{
  
  private Point location;
  private Color lightColor;
  
  public Light(Point location, Color lightColor){
    this.location = location;
    this.lightColor = lightColor;
  }
  
  public Point getPoint(){
    return location;
  }
  
  public Point getLightCenter(){
    return location;
  }
  
  public Color getColor(){
    return lightColor;
  }
  
}