public class Surface{
  private Color diffuseColor;
  private Color ambientColor;
  private Color specularColor;
  private float specularHighlightExponent;
  private float reflectiveCoefficient = 0;
  private float refractiveCoefficient;
  private float indexOfRefraction;
  private int noise;
  ProceduralTexture texture;
  
  public Surface(Color diffuseColor, Color ambientColor){
    this.diffuseColor = diffuseColor;
    this.ambientColor = ambientColor;
    noise = 0;
    texture = ProceduralTexture.NO_NOISE;
    reflectiveCoefficient = 0;
  }
  public Surface(Color diffuseColor, Color ambientColor, float reflectiveCoefficient){
    this.diffuseColor = diffuseColor;
    this.ambientColor = ambientColor;
    noise = 0;
    texture = ProceduralTexture.NO_NOISE;
    this.reflectiveCoefficient = reflectiveCoefficient;
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
    noise = 0;
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
  
  public String toString(){
    return diffuseColor.toString();
  }
  
  public void setNoise(int noise){
    this.noise = noise;
  }
  
  public int getNoise(){
    return noise;
  }
  
  public ProceduralTexture getTexture(){
    return texture;
  }
  public void setTexture(ProceduralTexture texture){
    this.texture = texture;
  }
  
}

public enum ProceduralTexture{
  NOISE, NO_NOISE, WOOD, MARBLE, STONE;
}