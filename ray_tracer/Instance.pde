public class Instance extends Shape{
  
  Shape shape;
  XMatrix3D transformation_matrix_inverse;
  
  public Instance(Shape shape, XMatrix3D transformation_matrix_inverse){
    this.shape = shape;
    this.transformation_matrix_inverse = transformation_matrix_inverse;
  }
  
  public String debug(){
    return "I am an instance";
  }
  
  public PVector shapeNormal(Point hitPoint){
    return new PVector();
  }
  
  public IntersectionObject intersects(Ray tempRay){
    return null;
  }
}