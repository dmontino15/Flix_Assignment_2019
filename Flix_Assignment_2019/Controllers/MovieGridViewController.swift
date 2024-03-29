//
//  MovieGridViewController.swift
//  Flix_Assignment_2019
//
//  Created by Daniella Montinola on 10/25/19.
//  Copyright © 2019 Daniella Montinola. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    

    // MARK: - Properties
    
    var movies = [[String: Any]]()
    
    @IBOutlet weak var superheroCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        superheroCollectionView.delegate = self
        superheroCollectionView.dataSource = self
        
        let layout = superheroCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        
        let width = (view.frame.size.width - layout.minimumInteritemSpacing * 2) / 3
        layout.itemSize = CGSize(width: width, height: width * 3 / 2)
        
        retrieveSuperheroMovies()
    }
    
    // MARK: - Private Function
    
    private func retrieveSuperheroMovies() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                self.movies = dataDictionary["results"] as! [[String: Any]]
                self.superheroCollectionView.reloadData()
                
                print(self.movies)
        }
    }
        task.resume()

    }
    
    // MARK: - Collection View Functions
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = superheroCollectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        
        let movie = movies[indexPath.item]
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        cell.moviePosterView.af_setImage(withURL: posterUrl!)
        
        
        return cell
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        let selectedFilm = sender as! UICollectionViewCell
        let indexPath = superheroCollectionView.indexPath(for: selectedFilm)!
        let movie = movies[indexPath.row]
        
        // Pass the selected object to the new view controller.
        let movieDetails = segue.destination as! SuperheroMovieDetailsViewController
        movieDetails.movie = movie
    }


}
