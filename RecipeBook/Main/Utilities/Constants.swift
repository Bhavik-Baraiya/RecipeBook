//
//  Constants.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 22/04/25.
//

import SwiftUI

//AppStorage constants

let darkModeSupport = "dark-mode"
let cloudSyncSupport = "cloud-sync"
let gridModeSupport = "grid-mode"

//Files and Folders

let appFolderName = "RecipeBook"
let recipeDataFolderName = "Recipes"
let recipeImagesFolderName = "RecipeImages"

// -- Extension for image file

let imageFileExtension = ".jpeg"

// -- Extension for video file

let videoFileExtension = ".mp4"

//Form Fields Titles

let label_RecipeTitleText:LocalizedStringKey = "Recipe Title"
let label_RecipeIngredientsText:LocalizedStringKey = "Recipe Ingredients"
let label_RecipeInstructionsText:LocalizedStringKey = "Recipe Instructions"
let label_SelectLevelText:LocalizedStringKey = "Select Difficulty Level"
let label_SelectCategoryText:LocalizedStringResource = "Select Category"
let label_SelectedCategoryText:LocalizedStringResource = "You Selected"
let label_UpdatePicturesText:LocalizedStringKey = "Update Pictures"
let label_AddMediaText:LocalizedStringKey = "Add Photos & Videos"
let label_PhotosHeadingLabel:LocalizedStringKey = "Photos"
let label_VideosHeadingLabel:LocalizedStringKey = "Videos"
let label_UploadMediaText:LocalizedStringKey = "Upload Media"
let label_PreparationTimeText:LocalizedStringKey = "Preparation Time"
let label_SelectedTimeText:LocalizedStringResource = "Selected Time"
let label_UploadText:LocalizedStringKey = "Upload Pictures"

//Form Fields Placeholders

let placeHolder_RecipeTitle:LocalizedStringKey = "Enter Recipe Title"
let placeHolder_RecipeIngredients:LocalizedStringKey = "Enter Recipe Ingredients"
let placeHolder_RecipeInstructions:LocalizedStringKey = "Enter Recipe Instructions"

//Form Warning Messages

let maxUploadWarning_Message:LocalizedStringKey = "*You Can Upload Maximum 5 Pictures"
let removeUploadedPhotos_Message:LocalizedStringKey = "You have to remove the addded photos in order to update"
let removeUploadedVideos_Message:LocalizedStringKey = "You have to remove the addded videos in order to update"
let popupTitle_InformationRequired:LocalizedStringKey = "Information Required!"
let popupMessage_InformationRequired:LocalizedStringKey = "You need to fill in the recipe information to proceed."
