using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class LoadSceneOnInput : MonoBehaviour {

    // declare mazeNumber
    public static int mazeNumber;

	// Use this for initialization
	void Start () {
		LoadSceneOnInput.mazeNumber = -1;
	}
	
	// Update is called once per frame
	void Update () {
		if (Input.GetAxis("Submit") == 1) {
			SceneManager.LoadScene("Play");
		}
	}
}
