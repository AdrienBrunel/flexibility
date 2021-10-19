# ==============================================================================
#  MY FUNCTIONS
# ==============================================================================

    ## Color to RGB vector -----------------------------------------------------
        function col2rgb(color)
            color_rgb = RGB(color)
            return [color_rgb.r,color_rgb.g,color_rgb.b]
        end

    ## RGB vector to color -----------------------------------------------------
        function rgb2col(color_rgb)
            return RGB(color_rgb[1],color_rgb[2],color_rgb[3])
        end

    ## Rectangle shape ---------------------------------------------------------
        rectangle(w, h, x, y) = Plots.Shape(x .+ [0,w,w,0], y .+ [0,0,h,h])

    ## Reserve cost ------------------------------------------------------------
        function ReserveCost(x,c)
            return (c' * x)[1]
        end

    ## Reserve boundary length -------------------------------------------------
        function ReserveBoundaryLength(x,B)
            return (x' * B * (1 .- x))[1]
        end

    ## Reserve score -----------------------------------------------------------
        function ReserveScore(x,c,B,BLM)
            return (c' * x .+ BLM * x' * B * (1 .- x))[1]
        end

    ## Reserve score -----------------------------------------------------------
        function PseudoDistance(x,y)
            return (x' * (1 .- y))[1]
        end

    ## Reserve score -----------------------------------------------------------
        function Distance(x,y)
            return PseudoDistance(x,y)+PseudoDistance(y,x)
        end
