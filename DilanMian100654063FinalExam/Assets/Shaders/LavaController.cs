using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LavaController : MonoBehaviour
{
    public Shader lavaShader;
    [NonSerialized]
    Material lava;

    [Range(0, 100)]
    public float speed;

    void Update()
    {

        if (Input.GetKeyDown(KeyCode.Alpha1))//increase the speed
        {
            speed = 50;
        }

        if (Input.GetKeyDown(KeyCode.Alpha2))//decrease speed
        {
            speed = 10;
        }
    }

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        lava.SetFloat("_Speed", speed);//connect this speed var to the shader's speed var
    }
}
