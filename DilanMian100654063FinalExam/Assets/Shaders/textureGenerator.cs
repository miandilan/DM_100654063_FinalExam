using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;

public class textureGenerator : MonoBehaviour
{
    public Texture2D noise;
    public Material perlinMaterial;
    public int width = 512;
    public int height = 512;
    public float scale = 1.0f;
    private int _nameCounter = 0;
    public ComputeShader perlinShader;
    public Color textureColor;

    private void SaveTexturesToJpg(Texture2D textureToSave)
    {
        byte[] bytes = textureToSave.EncodeToJPG();
        string filepath = "./Assets/JPG_" + _nameCounter + ".jpg";
        _nameCounter++;
        File.WriteAllBytes(filepath, bytes);
    }

    [ContextMenu("Generate Texture")]
    private void GenerateTexture()
    {
        // Create a new texture with the specified width and height
        noise = new Texture2D(width, height, TextureFormat.RGBA32, true);
        for(int i = 0; i < width; i++)
        {
            for(int j = 0; j < height; j++)
            {
                // Calculate the x and y coordinates of the pixel
                float xOrg = 0;
                float yOrg = 0;
                float xCoord = xOrg + i / (float)width * scale;
                float yCoord = yOrg + j / (float)height * scale;
                float sample = Mathf.PerlinNoise(xCoord, yCoord);
                noise.SetPixel(i, j, new Color(sample, sample, sample));
            }
        }
        // Apply the texture changes and save the texture as a JPG
        noise.Apply();
        SaveTexturesToJpg(noise);
    }

    [ContextMenu("Generate GPU Texture")]
    private void GenerateTextureGPU()
    {
        // Create a new texture with the specified width and height
        noise = new Texture2D(width, height, TextureFormat.RGBA32, true);
        int kernelHandle = perlinShader.FindKernel("CSMain");

        // Create a new RenderTexture to store the GPU-generated texture
        RenderTexture tempTexture = new RenderTexture(width, height, 0, RenderTextureFormat.ARGB32);
        tempTexture.enableRandomWrite = true;
        tempTexture.Create();
        // Execute the compute shader to generate the texture
        perlinShader.SetTexture(kernelHandle, "Result", tempTexture);
        float[] tempColor = new float[4];
        for(int i = 0; i < 4; i++)
        {
            tempColor[i] = textureColor[i];
        }

        perlinShader.SetFloats("color", tempColor);

        perlinShader.Dispatch(kernelHandle, width, height, 1);

        // Convert the RenderTexture to a Texture2D and save the texture as a JPG
        Texture2D texture2d = new Texture2D(width, height, TextureFormat.ARGB32, false);
        RenderTexture.active = tempTexture;
        texture2d.ReadPixels(new Rect(0, 0, tempTexture.width, tempTexture.height), 0, 0);
        texture2d.Apply();
        SaveTexturesToJpg(texture2d);
    }
}
