/*
 * GML - Go QML
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2019 Roland Singer <roland.singer[at]desertbit.com>
 * Copyright (c) 2019 Sebastian Borchers <sebastian[at]desertbit.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#include "gml_list_model.h"

//########################//
//### Static Variables ###//
//########################//

gml_list_model_row_count_cb_t gml_list_model_row_count_cb = NULL;
gml_list_model_data_cb_t      gml_list_model_data_cb      = NULL;

//#############//
//### C API ###//
//#############//

gml_list_model gml_list_model_new(void* go_ptr) {
    try {
        GmlListModel* glm = new GmlListModel(go_ptr);
        return (gml_list_model)glm;
    }
    catch (std::exception& e) {
        gml_error_log_exception(e.what());
        return NULL;
    }
    catch (...) {
        gml_error_log_exception();
        return NULL;
    }
}

void gml_list_model_free(gml_list_model lm) {
    if (lm == NULL) {
        return;
    }
    GmlListModel* glm = (GmlListModel*)lm;
    delete glm;
    lm = NULL;
}

void gml_list_model_cb_register(
    gml_list_model_row_count_cb_t rc_cb,
    gml_list_model_data_cb_t      d_cb
) {
    gml_list_model_row_count_cb = rc_cb;
    gml_list_model_data_cb      = d_cb;
}

//##########################//
//### GmlListModel Class ###//
//##########################//

GmlListModel::GmlListModel(
    void* goPtr
) :
    goPtr(goPtr) {}

int GmlListModel::rowCount(const QModelIndex& /*parent = QModelIndex()*/) const {
    // Call to go.
    return gml_list_model_row_count_cb(goPtr);
}

QVariant GmlListModel::data(const QModelIndex& index, int /*role = Qt::DisplayRole*/) const {
    // Call to go.
    gml_variant gmlV = gml_list_model_data_cb(goPtr, index.row());

    // Create a copy.
    QVariant v(*((QVariant*)gmlV));

    // Delete, because Go is not responsible for memory anymore.
    gml_variant_free(gmlV);

    return v;
}
