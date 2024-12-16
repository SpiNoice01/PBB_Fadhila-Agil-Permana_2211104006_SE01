#include <algorithm>
#include <iostream>
#include <queue>
#include <unordered_map>
#include <unordered_set>
#include <vector>
#include <deque>

using namespace std;

class Graph {
public:
    unordered_map<string, unordered_map<string, int>> adjList;

    void addEdge(const string& src, const string& dest, int weight) {
        adjList[src][dest] = weight;
        adjList[dest][src] = weight;
    }

    void printGraph() {
        for (const auto& pair : adjList) {
            cout << pair.first << ": ";
            for (const auto& neighbor : pair.second) {
                cout << "(" << neighbor.first << ", " << neighbor.second << ") ";
            }
            cout << endl;
        }
    }

    vector<string> bfsShortestPath(const string& start, const string& end) {
        unordered_map<string, string> previous;
        unordered_set<string> visited;
        queue<string> q;
        string current;

        visited.insert(start);
        q.push(start);
        previous[start] = current;

        while (!q.empty()) {
            current = q.front();
            q.pop();

            if (current == end) {
                break;
            }

            for (const auto& neighbor : adjList[current]) {
                if (visited.find(neighbor.first) == visited.end()) {
                    visited.insert(neighbor.first);
                    previous[neighbor.first] = current;
                    q.push(neighbor.first);
                }
            }
        }

        vector<string> path;
        current = end;

        while (current != "" && previous.find(current) != previous.end()) {
            path.push_back(current);
            current = previous[current];
        }

        reverse(path.begin(), path.end());

        return path;
    }

    vector<string> bfsAlternativePath(const string& start, const string& end, const vector<string>& shortestPath) {
        unordered_map<string, string> previous;
        unordered_set<string> visited;
        queue<string> q;
        string current;

        visited.insert(start);
        q.push(start);
        previous[start] = current;

        while (!q.empty()) {
            current = q.front();
            q.pop();

            if (current == end) {
                break;
            }

            for (const auto& neighbor : adjList[current]) {
                if (visited.find(neighbor.first) == visited.end() && shortestPath.end() == find(shortestPath.begin(), shortestPath.end(), neighbor.first)) {
                    visited.insert(neighbor.first);
                    previous[neighbor.first] = current;
                    q.push(neighbor.first);
                }
            }
        }

        vector<string> path;
        current = end;

        while (current != "" && previous.find(current) != previous.end()) {
            path.push_back(current);
            current = previous[current];
        }

        reverse(path.begin(), path.end());

        return path;
    }
};

int main() {
    Graph g;

    g.addEdge("A", "B", 3);
    g.addEdge("A", "D", 2);
    g.addEdge("B", "C", 4);
    g.addEdge("B", "D", 1);
    g.addEdge("C", "D", 2);
    g.addEdge("C", "E", 3);
    g.addEdge("D", "E", 4);

    string start = "A";
    string end = "E";

    vector<string> shortestPath = g.bfsShortestPath(start, end);

    if (!shortestPath.empty()) {
        cout << "Jalur terpendek dari " << start << " ke " << end << ": ";
        for (const auto& node : shortestPath) {
            cout << node << " ";
        }
        cout << endl;
    } else {
        cout << "Tidak ada jalur dari " << start << " ke " << end << endl;
    }

    vector<string> alternativePath = g.bfsAlternativePath(start, end, shortestPath);

    if (!alternativePath.empty()) {
        cout << "Jalur alternatif dari " << start << " ke " << end << ": ";
        for (const auto& node : alternativePath) {
            cout << node << " ";
        }
        cout << endl;
    } else {
        cout << "Tidak ada jalur alternatif dari " << start << " ke " << end << endl;
    }

    return 0;
}

