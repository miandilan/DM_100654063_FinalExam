using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ReflectionScript : MonoBehaviour
{
    public ReflectionProbe rProbe;
    public RenderTexture rText;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        rProbe.RenderProbe(rText);
    }
}
