public class Surface{
  private Color diffuseColor;
  private Color ambientColor;
  private Color specularColor;
  private float specularHighlightExponent;
  private float reflectiveCoefficient;
  private float refractiveCoefficient;
  private float indexOfRefraction;
  
  public Surface(Color diffuseColor, Color ambientColor){
    this.diffuseColor = diffuseColor;
    this.ambientColor = ambientColor;
  }
  public Surface(Color diffuseColor, Color ambientColor, Color specularColor, 
                  float specularHighlightExponent, float reflectiveCoefficient, float refractiveCoefficient, float indexOfRefraction){
    this.diffuseColor = diffuseColor;
    this.ambientColor = ambientColor;
    this.specularColor = specularColor;
    
    this.specularHighlightExponent = specularHighlightExponent;
    this.reflectiveCoefficient = reflectiveCoefficient;
    this.refractiveCoefficient = refractiveCoefficient;
    this.indexOfRefraction = indexOfRefraction;
  }
  
  public Color getDiffuseColor(){
    return diffuseColor;
  }
  
  public Color getAmbientColor(){
    return ambientColor;
  }
  
  public Color getSpecularColor(){
    return specularColor;
  }
  
  public float getSpecularHighlightExponent(){
    return specularHighlightExponent;
  }
  
  public float getReflectiveCoefficient(){
    return reflectiveCoefficient;
  }
  
  public float getRefractiveCoefficient(){
    return refractiveCoefficient;
  }
  
  public float getIndexOfRefraction(){
    return indexOfRefraction;
  }
  
}