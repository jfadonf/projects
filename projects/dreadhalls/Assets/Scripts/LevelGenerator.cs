using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LevelGenerator : MonoBehaviour {

	public GameObject floorPrefab;
	public GameObject wallPrefab;
	public GameObject ceilingPrefab;

	public GameObject characterController;

	public GameObject floorParent;
	public GameObject wallsParent;

	// allows us to see the maze generation from the scene view
	public bool generateRoof = true;

	// number of times we want to "dig" in our maze
	public int tilesToRemove = 350;

	public int mazeSize;

	// spawns at the end of the maze generation
	public GameObject pickup;

	// this will determine whether we've placed the character controller
	private bool characterPlaced = false;

	// 2D array representing the map
	private int[,] mapData;

	// we use these to dig through our maze and to spawn the pickup at the end
	private int mazeX = 4, mazeY = 1;

    // how many gaps do we need
    public int gapsPer100Tiles = 1;
    private int quantityOfGaps;
    private List<int> positionsOfGaps;

	// Use this for initialization
	void Start () {

        LoadSceneOnInput.mazeNumber = LoadSceneOnInput.mazeNumber + 1;

        // how many gaps do we need
        quantityOfGaps = (int)(mazeSize * mazeSize / 100 * gapsPer100Tiles);

        // determines the postions of the gaps in the row of the hallway
        positionsOfGaps = picker(tilesToRemove - 2, quantityOfGaps);

		// initialize map 2D array
		mapData = GenerateMazeData();

		// create actual maze blocks from maze boolean data
		for (int z = 0; z < mazeSize; z++) {
			for (int x = 0; x < mazeSize; x++) {
				if (mapData[z, x] == 1) {
					CreateChildPrefab(wallPrefab, wallsParent, x, 1, z);
					CreateChildPrefab(wallPrefab, wallsParent, x, 2, z);
					CreateChildPrefab(wallPrefab, wallsParent, x, 3, z);
                    
                    // create floor
                    CreateChildPrefab(floorPrefab, floorParent, x, 0, z);
				} else if (mapData[z, x] == 0) {
                    
                    // create floor
                    CreateChildPrefab(floorPrefab, floorParent, x, 0, z);
                    if (!characterPlaced) {
					
                        // place the character controller on the first empty wall we generate
                        characterController.transform.SetPositionAndRotation(
                            new Vector3(x, 1, z), Quaternion.identity
                        );

                        // flag as placed so we never consider placing again
                        characterPlaced = true;
                    }

				}

                // create roof
				if (generateRoof) {
					CreateChildPrefab(ceilingPrefab, wallsParent, x, 4, z);
				}
			}
		}

		// spawn the pickup at the end
		var myPickup = Instantiate(pickup, new Vector3(mazeX, 1, mazeY), Quaternion.identity);
		myPickup.transform.localScale = new Vector3(0.25f, 0.25f, 0.25f);
	}

	// generates the booleans determining the maze, which will be used to construct the cubes
	// actually making up the maze
	int[,] GenerateMazeData() {
		int[,] data = new int[mazeSize, mazeSize];

		// initialize all walls to true
		for (int y = 0; y < mazeSize; y++) {
			for (int x = 0; x < mazeSize; x++) {
				data[y, x] = 1;
			}
		}

		// counter to ensure we consume a minimum number of tiles
		int tilesConsumed = 0;

		// iterate our random crawler, clearing out walls and straying from edges
		while (tilesConsumed < tilesToRemove) {
			
			// directions we will be moving along each axis; one must always be 0
			// to avoid diagonal lines
			int xDirection = 0, yDirection = 0;

			if (Random.value < 0.5) {
				xDirection = Random.value < 0.5 ? 1 : -1;
			} else {
				yDirection = Random.value < 0.5 ? 1 : -1;
			}

			// random number of spaces to move in this line
			int numSpacesMove = (int)(Random.Range(1, mazeSize - 1));

			// move the number of spaces we just calculated, clearing tiles along the way
			for (int i = 0; i < numSpacesMove; i++) {
				mazeX = Mathf.Clamp(mazeX + xDirection, 1, mazeSize - 2);
				mazeY = Mathf.Clamp(mazeY + yDirection, 1, mazeSize - 2);

				if (data[mazeY, mazeX] == 1) {
					if (positionsOfGaps.Contains(tilesConsumed)) {
                        data[mazeY, mazeX] = 2;
                        tilesConsumed++;
                    } else {
                        data[mazeY, mazeX] = 0;
                        tilesConsumed++;
                    }
				}
			}
		}

		return data;
	}

	// allow us to instantiate something and immediately make it the child of this game object's
	// transform, so we can containerize everything. also allows us to avoid writing Quaternion.
	// identity all over the place, since we never spawn anything with rotation
	void CreateChildPrefab(GameObject prefab, GameObject parent, int x, int y, int z) {
		var myPrefab = Instantiate(prefab, new Vector3(x, y, z), Quaternion.identity);
		myPrefab.transform.parent = parent.transform;
	}

    // function picker, return a list of unique numbers which are randomly picked up in a range 
    List<int> picker(int range, int timesOfPick)
    {
        // declaration of result list
        List<int> result = new List<int>();

        // declaration of a list of serial numbers, fill in serial numbers
        List<int> serialNumberList = new List<int>();
        for (int i = 1; i <= range; i++)
        {
            serialNumberList.Add(i);
        }

        // picks randomly numbers up to result list 
        for (int i = 0; i < timesOfPick; i++)
        {
            int randomIndex = Random.Range(0, serialNumberList.Count);
            int selectedNumber = serialNumberList[randomIndex];

            result.Add(selectedNumber);
            serialNumberList.RemoveAt(randomIndex);
        }

        return result;
    }
}


