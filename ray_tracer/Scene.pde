public class Scene{
  
  private Color background;
  private float fov;
  private ArrayList<PointLight> pointLights;                                   // TODO THIS NEEDS TO BE A LIST
  private ArrayList<Sphere> allObjects = new ArrayList<Sphere>();  // TODO CHANGE TO ABSTRACT CLASS

  
  public Scene(){
    background = new Color();
    fov = 0;
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
  
  public void addShape(Sphere currObject){              // TODO CHANGE TO ABSTRACT CLASS
    allObjects.add(currObject);
  }
  
}