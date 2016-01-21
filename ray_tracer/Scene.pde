public class Scene{
  
  private Color background;
  private float fov;
  private ArrayList<PointLight> pointLights;                                   // TODO THIS NEEDS TO BE A LIST
  private ArrayList<Shape> allObjects;  // TODO CHANGE TO ABSTRACT CLASS

  
  public Scene(){
    background = new Color();
    fov = 0;
    pointLights = new ArrayList<PointLight>();
    allObjects = new ArrayList<Shape>();
  }
  
  public void setBackground(Color background){
    this.background = background;
  }
  
  public void setBackground(float R, float G, float B){
    background.setRGB(R, G, B);
  }
  
  public Color getBackground(){
    return background;
  }
  
  public void setFOV(float fov){
    this.fov = fov;
  }
  
  public float getFOV(){
    return fov;
  }
  
  public void addPointLight(PointLight pointLight){
    pointLights.add(pointLight);
  }
  
  public void addShape(Shape currObject){              // TODO CHANGE TO ABSTRACT CLASS
    allObjects.add(currObject);
  }
  
  public ArrayList<Shape> getAllObjects(){
    return allObjects;
  }
  
  public ArrayList<PointLight> getPointLights(){
    return pointLights;
  }
  
}