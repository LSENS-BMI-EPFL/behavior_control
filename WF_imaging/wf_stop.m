function wf_stop(dummy)
    global WF_S Cam_vec LED1_vec LED2_vec
    if WF_S.Running
        stop(WF_S)
        write(WF_S, [zeros(1,50000)', zeros(1,50000)', zeros(1,50000)'])
        write(WF_S, [Cam_vec(1:length(Cam_vec)/2); LED1_vec(1:length(Cam_vec)/2); LED2_vec(1:length(Cam_vec)/2)]')
        write(WF_S, [zeros(1,50000)', zeros(1,50000)', zeros(1,50000)'])
        
        while WF_S.Running
            continue
        end
        WF_S.delete()
    else
        write(WF_S, [zeros(1,50000)', zeros(1,50000)', zeros(1,50000)'])
    end
end

