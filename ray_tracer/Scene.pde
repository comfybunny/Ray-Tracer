import java.util.Map;

public class Scene{
  
  private Color background;
  private float fov;
  private ArrayList<Light> lights;                                   // TODO THIS NEEDS TO BE A LIST
  private ArrayList<Shape> allObjects;  // TODO CHANGE TO ABSTRACT CLASS
  private Lens lens;
  private MatrixStack stack;
  private HashMap<String, Shape> named_objects;
  private int start_list;
  private int rays_per_pixel;
  int num_cast;  //each light sourse casts this many caustic photons into the scene
  int num_near;  // query kd tree to find this many
  float max_near_dist; //given to kd tree
  boolean caustic = false;
  boolean diffuse = false;
    
  public Scene(){
    background = new Color();
    fov = 0;
    lights = new ArrayList<Light>();
    allObjects = new ArrayList<Shape>();
    
    stack = new MatrixStack();
    rays_per_pixel = 1;
    lens = null;
    named_objects = new HashMap<String, Shape>();
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
  
  public void addLight(Light light){
    lights.add(light);
  }
  
  public void addLens(Lens lens){
    this.lens = lens;
  }
  
  public void addShape(Shape currObject){              // TODO CHANGE TO ABSTRACT CLASS
    allObjects.add(currObject);
  }
  
  public ArrayList<Shape> getAllObjects(){
    return allObjects;
  }
  
  public int numberOfObjects(){
    return allObjects.size();
  }
  public ArrayList<Light> getLights(){
    return lights;
  }
  
  public MatrixStack getMatrixStack(){
    return stack;
  }
  
  public int getRaysPerPixel(){
    return rays_per_pixel;
  }
  
  public Lens getLens(){
    return lens;
  }
  
  public void setRaysPerPixel(int rayNum){
    rays_per_pixel = rayNum;
  }
  
  public Shape popLastShape(){
    Shape lastShape = allObjects.get(allObjects.size()-1);
    allObjects.remove(allObjects.size()-1);
    return lastShape;
  }
  
  public void add_named_object(String object_name, Shape object){
    named_objects.put(object_name, object);
  }
  
  
  public Shape getInstance(String string){
    return named_objects.get(string);
  }
  
  public int getListStartIndex(){
    return start_list;
  }
  
  public void setListStartIndex(int index){
    start_list = index;
  }
  
  public void causticTrue(int numcast, int numnear, float neardist){
    diffuse = false;
    caustic = true;
    num_cast = numcast;
    num_near = numnear;
    max_near_dist = neardist;
  }
  public void diffuseTrue(int numcast, int numnear, float neardist){
    caustic = false;
    diffuse = true;
    num_cast = numcast;
    num_near = numnear;
    max_near_dist = neardist;
  }
}