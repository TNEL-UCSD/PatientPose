#ifndef CAFFE_EUCLIDEAN_LOSS_HEATMAP_HPP_
#define CAFFE_EUCLIDEAN_LOSS_HEATMAP_HPP_

#include <vector>
#include <boost/timer/timer.hpp>
#include <opencv2/core/core.hpp>

#include "caffe/blob.hpp"
#include "caffe/layer.hpp"
#include "caffe/proto/caffe.pb.h"

#include "caffe/layers/loss_layer.hpp"

namespace caffe
{


template <typename Dtype>
class EuclideanLossHeatmapLayer : public LossLayer<Dtype> {
public:
  explicit EuclideanLossHeatmapLayer(const LayerParameter& param)
    : LossLayer<Dtype>(param), diff_() {}
  virtual void Reshape(const vector<Blob<Dtype>*>& bottom,
                       const vector<Blob<Dtype>*>& top);

  virtual inline int ExactNumBottomBlobs() const { return 3; }

  virtual void LayerSetUp(const vector<Blob<Dtype>*>& bottom,
                          const vector<Blob<Dtype>*>& top);
//  virtual void LayerSetUp(const vector<Blob<Dtype>*>& bottom, const vector<Blob<Dtype>*>& top);

  virtual inline const char* type() const { return "EuclideanLossHeatmap"; }

  /**
   * Unlike most loss layers, in the EuclideanLossLayer we can backpropagate
   * to both inputs -- override to return true and always allow force_backward.
   */
  virtual inline bool AllowForceBackward(const int bottom_index) const {
    return true;
  }

protected:
  /// @copydoc EuclideanLossLayer
  virtual void Forward_cpu(const vector<Blob<Dtype>*>& bottom,
                           const vector<Blob<Dtype>*>& top);
  virtual void Forward_gpu(const vector<Blob<Dtype>*>& bottom,
                           const vector<Blob<Dtype>*>& top);
  virtual void Backward_cpu(const vector<Blob<Dtype>*>& top,
                            const vector<bool>& propagate_down, const vector<Blob<Dtype>*>& bottom);
  virtual void Backward_gpu(const vector<Blob<Dtype>*>& top,
                            const vector<bool>& propagate_down, const vector<Blob<Dtype>*>& bottom);

  Blob<Dtype> diff_;

  Blob<Dtype> img_pred_;

  // validation mode flag
  bool val_mode_;
};



}

#endif /* CAFFE_EUCLIDEAN_LOSS_HEATMAP_HPP_ */
