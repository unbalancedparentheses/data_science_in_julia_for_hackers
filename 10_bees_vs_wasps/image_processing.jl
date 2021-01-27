## *USAGE*: 
## arg1: directory with images
## arg2: final resolution of photos
## example: julia image_processing.jl data_images 120

using Images
using ProgressMeter

function resize_and_grayify(directory, im_name, width::Int64, height::Int64)
    resized_gray_img = Gray.(load(directory * "/" * im_name)) |> (x -> imresize(x, width, height))
    try
        save("preprocessed_" * directory * "/" * im_name, resized_gray_img)
    catch e
        if isa(e, SystemError)
            mkdir("preprocessed_" * directory)
            save("preprocessed_" * directory * "/" * im_name, resized_gray_img)
        end
    end
end

function process_images(directory, width::Int64, height::Int64)
    files_list = readdir(directory)
    #@showprogress resize_and_grayify.(directory, files_list, width, height)
    @showprogress map(x -> resize_and_grayify(directory, x, width, height), files_list)
end

dir = ARGS[1]
N = parse(Int64, ARGS[2])

process_images(dir, N, N)

