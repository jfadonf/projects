using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class MazeText : MonoBehaviour
{
    
    public Text mazeText;
    

    // Start is called before the first frame update
    void Start()
    {
    
    }

    // Update is called once per frame
    void Update()
    {
        mazeText.text = "Level: " + LoadSceneOnInput.mazeNumber; 
    }
}
