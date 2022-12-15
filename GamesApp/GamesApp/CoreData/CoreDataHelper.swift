//
//  CoreDataHelper.swift
//  GamesApp
//
//  Created by Habip Yeşilyurt on 14.12.2022.
//

import Foundation

enum CoreDataError: String, Error {
    case savingError   = "Data couldn't be saved"
    case removingError = "Data couldn't be removed"
    case fetchingError = "Data couldn't be fetched"
    case checkingError = "Data couldn't be checked"
    case dataError     = "Data couldn't be find"
    case noError
}

protocol CoreDataProtocol {
    associatedtype T
    func saveData(data: T, completion: @escaping (_ isSuccess: Bool, CoreDataError)->())
    func fetchData(completion: @escaping ([T]?, CoreDataError)->())
    func deleteData(id: Int, completion: @escaping (_ isSuccess: Bool, CoreDataError)->())
}
