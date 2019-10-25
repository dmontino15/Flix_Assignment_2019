//
//  MoviesViewController.swift
//  Flix_Assignment_2019
//
//  Created by Daniella Montinola on 10/14/19.
//  Copyright © 2019 Daniella Montinola. All rights reserved.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    var movies = [[String: Any]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        retrieveMovieLists()
        tableView.dataSource = self
        tableView.delegate = self
    }
    

    // MARK: - Private Function
    
    private func retrieveMovieLists() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                // i want you to look inside dataDictionary and i want you to get out resutls and store it inside movies
                self.movies = dataDictionary["results"] as! [[String: Any]]
                
                self.tableView.reloadData()
                
                print(dataDictionary)
        }
    }
        task.resume()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // dequeue reusable cell is recycling the cells instead of creating new ones over and over again
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        
        cell.movieTitleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        cell.posterView.af_setImage(withURL: posterUrl!)
        
        return cell
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destination.
        let cell = sender as! UITableViewCell
        let movieCellIndex = tableView.indexPath(for: cell)!
        let movie = movies[movieCellIndex.row]
        
        
        // Pass the selected object to the new view controller.
        let movieDetails = segue.destination as! MovieDetailsViewController
        movieDetails.movie = movie
        
        // deselect cell
        tableView.deselectRow(at: movieCellIndex, animated: true)
    }

}
