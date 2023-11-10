using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class win : MonoBehaviour
{
    private Text text;

	// Use this for initialization
	void Start () {
		text = GetComponent<Text>();
        text.text = "You You!";

		// start text off as completely transparent black
		text.color = new Color(0, 0, 0, 0);
	}

	// Update is called once per frame
	void Update () {
        // if the player collide with the end collider
		if (endzone.isReachTheEnd == 3) {

			// reveal text 
			text.color = new Color(1, 1, 1, 1);
            text.text = "You Won!";
        }
	}

}
