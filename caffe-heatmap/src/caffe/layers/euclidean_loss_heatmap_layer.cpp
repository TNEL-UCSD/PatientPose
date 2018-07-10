#include <vector>

#include "caffe/layers/euclidean_loss_heatmap_layer.hpp"
#include "caffe/util/math_functions.hpp"

// Euclidean loss layer that computes loss on a [x] x [y] x [ch] set of heatmaps

namespace caffe {

template <typename Dtype>
void EuclideanLossHeatmapLayer<Dtype>::Reshape(
    const vector<Blob<Dtype>*>& bottom, const vector<Blob<Dtype>*>& top) {
    LossLayer<Dtype>::Reshape(bottom, top);
    CHECK_EQ(bottom[0]->channels(), bottom[1]->channels());
    CHECK_EQ(bottom[0]->height(), bottom[1]->height());
    CHECK_EQ(bottom[0]->width(), bottom[1]->width());
    diff_.Reshape(bottom[0]->num(), bottom[0]->channels(),
                  bottom[0]->height(), bottom[0]->width());
}


template<typename Dtype>
void EuclideanLossHeatmapLayer<Dtype>::LayerSetUp(const vector<Blob<Dtype>*>& bottom, const vector<Blob<Dtype>*>& top)
{
    if (this->layer_param_.loss_weight_size() == 0) {
        this->layer_param_.add_loss_weight(Dtype(1));
    }

}

template <typename Dtype>
void EuclideanLossHeatmapLayer<Dtype>::Forward_cpu(const vector<Blob<Dtype>*>& bottom,
        const vector<Blob<Dtype>*>& top)
{
    Dtype loss = 0;

    const Dtype* bottom_pred = bottom[0]->cpu_data(); // predictions for all images
    const Dtype* gt_pred = bottom[1]->cpu_data();    // GT predictions
    const int num_images = bottom[1]->num();
    const int label_height = bottom[1]->height();
    const int label_width = bottom[1]->width();
    const int num_channels = bottom[0]->channels();

    DLOG(INFO) << "bottom size: " << bottom[0]->height() << " " << bottom[0]->width() << " " << bottom[0]->channels();

    const int label_channel_size = label_height * label_width;
    const int label_img_size = label_channel_size * num_channels;

    // Loop over images
    for (int idx_img = 0; idx_img < num_images; idx_img++)
    {
        // Compute loss
        for (int idx_ch = 0; idx_ch < num_channels; idx_ch++)
        {
            for (int i = 0; i < label_height; i++)
            {
                for (int j = 0; j < label_width; j++)
                {
                    int image_idx = idx_img * label_img_size + idx_ch * label_channel_size + i * label_height + j;
                    float diff = (float)bottom_pred[image_idx] - (float)gt_pred[image_idx];
            
                    // Set Euclidean loss to 0 for missing joints (-999)        
        		    if((float)gt_pred[image_idx] == -999) {
        		    	diff = 0;	
        		    }

        		    loss += diff * diff;

                }
            }
        }
    }

    DLOG(INFO) << "total loss: " << loss;
    loss /= (num_images * num_channels * label_channel_size);
    DLOG(INFO) << "total normalised loss: " << loss;

    top[0]->mutable_cpu_data()[0] = loss;
}


template <typename Dtype>
void EuclideanLossHeatmapLayer<Dtype>::Backward_cpu(const vector<Blob<Dtype>*>& top,
        const vector<bool>& propagate_down, const vector<Blob<Dtype>*>& bottom)
{
    const int count = bottom[0]->count();

    caffe_sub(count, bottom[0]->cpu_data(), bottom[1]->cpu_data(), diff_.mutable_cpu_data());

    // copy the gradient
    memcpy(bottom[0]->mutable_cpu_diff(), diff_.cpu_data(), sizeof(Dtype) * count);
    memcpy(bottom[1]->mutable_cpu_diff(), diff_.cpu_data(), sizeof(Dtype) * count);
}


#ifdef CPU_ONLY
STUB_GPU(EuclideanLossHeatmapLayer);
#endif

INSTANTIATE_CLASS(EuclideanLossHeatmapLayer);
REGISTER_LAYER_CLASS(EuclideanLossHeatmap);


}  // namespace caffe
